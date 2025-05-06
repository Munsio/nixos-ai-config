# NixOS Configuration with Flakes and Home-Manager (AI-Built)

This repository contains a modular NixOS configuration using flakes and home-manager, built entirely with AI assistance. It supports multiple hosts and users, with a flexible module system for both NixOS and home-manager configurations.

## Structure

The current repository structure:

```
.
├── flake.nix                 # Main flake configuration
├── flake.lock                # Flake lock file
├── shell.nix                 # Development shell configuration
├── statix.toml               # Statix linter configuration
├── hosts                     # Host-specific configurations
│   ├── default.nix           # Common host configuration
│   └── example/              # Example host configuration
│       ├── default.nix       # Host implementation
│       └── home.nix          # Host-specific home configuration
├── users                     # User-specific configurations
│   └── example-user/         # Example user configuration
│       ├── default.nix       # User implementation
│       └── home.nix          # User home configuration
├── modules/                  # NixOS modules
│   ├── README.md             # Module system documentation
│   ├── features/             # Feature modules (root level)
│   │   └── cli-tools.nix     # Example feature module installing CLI tools
│   ├── bundles/              # Bundle modules (nixModules.bundles)
│   │   └── development.nix   # Example bundle module
│   └── services/             # Service modules (nixModules.services)
│       └── ssh.nix           # Example service module
├── home/                     # Home-manager modules
│   ├── README.md             # Home module system documentation
│   ├── features/             # Feature modules (root level)
│   │   └── git.nix           # Git configuration module
│   ├── bundles/              # Bundle modules (homeModules.bundles)
│   │   └── development.nix   # Development bundle module
│   └── services/             # Service modules (homeModules.services)
│       └── ssh.nix           # SSH service module
└── lib/                      # Library functions
    ├── modules.nix           # Module system implementation
    └── system.nix            # System configuration helpers
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
2. Create two configuration files in this directory:
   - `default.nix`: Contains NixOS-specific user configuration (user account, permissions, groups)
   - `home.nix`: Contains home-manager related configuration (dotfiles, user environment)
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

1. Create a new `.nix` file in the `home/features` directory, e.g., `home/features/development.nix`
2. Add your module configuration to this file
3. Enable the module in a host or user configuration:

```nix
# Can be used in hosts/my-laptop/home.nix or users/alice/home.nix
homeModules = {
  # Enable the feature module directly at root level
  development = true;
};
```

#### Adding a Bundle Module

1. Create a new `.nix` file in the `home/bundles` directory, e.g., `home/bundles/coding.nix`
2. Add your module configuration to this file
3. Enable the module in a host or user configuration:

```nix
# Can be used in hosts/my-laptop/home.nix or users/alice/home.nix
homeModules = {
  bundles = {
    # Enable the bundle module in the bundles section
    coding = true;
  };
};
```

#### Adding a Service Module

1. Create a new `.nix` file in the `home/services` directory, e.g., `home/services/media.nix`
2. Add your module configuration to this file
3. Enable the module in a host or user configuration:

```nix
# Can be used in hosts/my-laptop/home.nix or users/alice/home.nix
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

### Comparing Changes

Before applying a new configuration, you can compare the changes that would be made to your current system:

```bash
# Show a diff of what would change in your system configuration
nixos-rebuild build --flake .#$(hostname) --dry-run

# Show a more detailed diff including what would be added/removed from your system
nixos-rebuild build --flake .#$(hostname) --dry-activate

# Compare the current system closure with the new one
nix store diff-closures /run/current-system ./result

# List the dependencies of the new system configuration
nix-store -q --references ./result

# Show what packages would be installed/removed for a specific user
home-manager build --flake .#$(hostname) --dry-run
```

These commands help you understand the impact of your changes before applying them, which is especially useful when making significant modifications to your system configuration.

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

## Recent Changes

Recent updates to the repository include:

1. Reorganized the home-manager modules from `home-modules/` to `home/` for better consistency
2. Added specific home configuration files for hosts (`hosts/example/home.nix`)
3. Added Git configuration module in `home/features/git.nix`
4. Added SSH service modules for both NixOS and home-manager
5. Improved the module system implementation in `lib/modules.nix` and `lib/system.nix`
6. Added CI/CD workflow for Nix linting

## API Costs

As it is not possible for Cline to read its own history yet, the costs have to be tracked manually.

Currently the costs are at approximately $18.

## About This Configuration

This NixOS configuration was created entirely with [Cline](https://github.com/cline-ai/cline) and Claude-3.7-sonnet as an experiment for AI-assisted system configuration. The modular structure and organization of this configuration demonstrates how AI assistants can help create well-structured, maintainable NixOS configurations with clear separation of concerns between different types of modules (features, bundles, and services).

All code, documentation, and configuration in this repository was generated with AI assistance, showcasing the potential of AI-driven system configuration management.
