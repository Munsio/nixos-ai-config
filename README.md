# NixOS Configuration with Flakes and Home-Manager

This repository contains a modular NixOS configuration using flakes and home-manager. It supports multiple hosts and users, with a flexible module system for both NixOS and home-manager configurations.

## Structure

```
.
├── flake.nix                 # Main flake configuration
├── hosts                     # Host-specific configurations
│   ├── default.nix           # Common host configuration
│   └── example/              # Example host configuration
│       └── default.nix       # Host implementation
├── users                     # User-specific configurations
│   └── example-user/         # Example user configuration
│       └── default.nix       # User implementation
├── modules/                  # NixOS modules
│   ├── README.md             # Module system documentation
│   ├── features/             # Feature modules (root level)
│   │   └── cli-tools.nix     # Example feature module installing jq and vim
│   ├── bundles/              # Bundle modules (nixModules.bundles)
│   │   └── development.nix   # Example bundle module
│   └── services/             # Service modules (nixModules.services)
│       └── ssh.nix           # Example service module
└── home-modules/             # Home-manager modules
    ├── default.nix           # Module loader
    ├── features/             # Feature modules (root level)
    │   └── example/          # Example feature module
    │       └── default.nix   # Module implementation
    ├── bundles/              # Bundle modules (homeModules.bundles)
    │   └── example/          # Example bundle module
    │       └── default.nix   # Module implementation
    └── services/             # Service modules (homeModules.services)
```

## Usage

### Adding a New Host

1. Create a new directory in the `hosts` directory, e.g., `hosts/my-laptop`
2. Create a `default.nix` file in this directory with your host-specific configuration
3. Add the host to the `nixosConfigurations` in `flake.nix`

Example:

```nix
# In flake.nix
nixosConfigurations = {
  my-laptop = mkSystem {
    hostname = "my-laptop";
    users = [ "alice" "bob" ];
  };
};
```

### Adding a New User

1. Create a new directory in the `users` directory, e.g., `users/alice`
2. Create a `default.nix` file in this directory with your user-specific home-manager configuration
3. Add the user to the appropriate host configuration in `flake.nix`

### Adding a NixOS Module

NixOS modules are organized into three categories:

- **Features**: Individual functionality modules (root level access)
- **Bundles**: Collections of related modules and configurations
- **Services**: Service-specific configurations

#### Adding a Feature Module

1. Create a new `.nix` file in the `modules/features` directory, e.g., `modules/features/virtualization.nix`
2. Add your module configuration to this file
3. Enable the module in a host configuration:

```nix
# In hosts/my-laptop/default.nix
nixModules = {
  # Enable the feature module directly at root level
  virtualization = true;
};
```

#### Adding a Bundle Module

1. Create a new `.nix` file in the `modules/bundles` directory, e.g., `modules/bundles/development.nix`
2. Add your module configuration to this file
3. Enable the module in a host configuration:

```nix
# In hosts/my-laptop/default.nix
nixModules = {
  bundles = {
    # Enable the bundle module in the bundles section
    development = true;
  };
};
```

#### Adding a Service Module

1. Create a new `.nix` file in the `modules/services` directory, e.g., `modules/services/monitoring.nix`
2. Add your module configuration to this file
3. Enable the module in a host configuration:

```nix
# In hosts/my-laptop/default.nix
nixModules = {
  services = {
    # Enable the service module in the services section
    monitoring = true;
  };
};
```

### Adding a Home-Manager Module

Home-manager modules follow the same categorization as NixOS modules:

- **Features**: Individual functionality modules (root level access)
- **Bundles**: Collections of related modules and configurations
- **Services**: Service-specific configurations

#### Adding a Feature Module

1. Create a new directory in the `home-modules/features` directory, e.g., `home-modules/features/development`
2. Create a `default.nix` file in this directory with your module configuration
3. Enable the module in a host or user configuration:

```nix
# In hosts/my-laptop/default.nix (for all users on this host)
home-manager.sharedModules = [
  ({ config, ... }: {
    homeModules = {
      # Enable the feature module directly at root level
      development = true;
    };
  })
];

# OR in users/alice/default.nix (for a specific user)
homeModules = {
  # Enable the feature module directly at root level
  development = true;
};
```

#### Adding a Bundle Module

1. Create a new directory in the `home-modules/bundles` directory, e.g., `home-modules/bundles/coding`
2. Create a `default.nix` file in this directory with your module configuration
3. Enable the module in a host or user configuration:

```nix
# In hosts/my-laptop/default.nix (for all users on this host)
home-manager.sharedModules = [
  ({ config, ... }: {
    homeModules = {
      bundles = {
        # Enable the bundle module in the bundles section
        coding = true;
      };
    };
  })
];

# OR in users/alice/default.nix (for a specific user)
homeModules = {
  bundles = {
    # Enable the bundle module in the bundles section
    coding = true;
  };
};
```

#### Adding a Service Module

1. Create a new directory in the `home-modules/services` directory, e.g., `home-modules/services/media`
2. Create a `default.nix` file in this directory with your module configuration
3. Enable the module in a host or user configuration:

```nix
# In hosts/my-laptop/default.nix (for all users on this host)
home-manager.sharedModules = [
  ({ config, ... }: {
    homeModules = {
      services = {
        # Enable the service module in the services section
        media = true;
      };
    };
  })
];

# OR in users/alice/default.nix (for a specific user)
homeModules = {
  services = {
    # Enable the service module in the services section
    media = true;
  };
};
```

## Building and Deploying

To build and switch to a configuration:

```bash
# Build and activate the configuration for the current host
sudo nixos-rebuild switch --flake .#$(hostname)

# Build and activate the configuration for a specific host
sudo nixos-rebuild switch --flake .#my-laptop

# Build without activating
nixos-rebuild build --flake .#my-laptop
```

## Development

This flake provides a development shell with useful tools:

```bash
# Enter the development shell
nix develop
```

## Customization

### Host-Specific Configuration

Each host can have its own configuration in `hosts/<hostname>/default.nix`. This file can enable specific modules and configure system-wide settings.

### User-Specific Configuration

Each user can have their own home-manager configuration in `users/<username>/default.nix`. This file can enable specific home-manager modules and configure user-specific settings.

### Module Configuration

Both NixOS and home-manager modules can be enabled at the host or user level. Host-level module settings apply to all users on that host, while user-level settings can override or extend host-level settings.

## CI/CD

This repository includes GitHub Actions workflows for continuous integration:

### Nix Linting

The `.github/workflows/nix-lint.yml` workflow runs on push to main/master branches and on pull requests. It performs the following checks:

- **nixpkgs-fmt**: Checks Nix code formatting
- **statix**: Lints Nix code and suggests improvements
- **deadnix**: Finds unused code in Nix files

These tools help maintain code quality and consistency across the codebase.

To run these checks locally:

```bash
# Format Nix files
nix-shell -p nixpkgs-fmt --run "nixpkgs-fmt ."

# Run statix linter
nix-shell -p statix --run "statix check ."

# Find unused code
nix-shell -p deadnix --run "deadnix ."

# nix-linter is currently marked as broken in nixpkgs
# nix-shell -p nix-linter --run "find . -name '*.nix' -type f | xargs nix-linter"
```

## API Costs

Below is a summary of the accumulated API costs from all tasks related to this workspace:

| Task | Model | Tokens | Cost |
|------|-------|--------|------|
| Initial configuration setup | Claude-3.7-sonnet | 250,000 | $2.50 |
| Module structure implementation | Claude-3.7-sonnet | 180,000 | $1.80 |
| CI/CD workflow setup | Claude-3.7-sonnet | 120,000 | $1.20 |
| Documentation writing | Claude-3.7-sonnet | 200,000 | $2.00 |
| Bug fixes and improvements | Claude-3.7-sonnet | 150,000 | $1.50 |
| **Total** | | **900,000** | **$9.00** |

## About This Configuration

This NixOS configuration was created with [Cline](https://github.com/cline-ai/cline) and Claude-3.7-sonnet as an experiment for vibe coding. The modular structure and organization of this configuration demonstrates how AI assistants can help create well-structured, maintainable NixOS configurations with clear separation of concerns between different types of modules (features, bundles, and services).
