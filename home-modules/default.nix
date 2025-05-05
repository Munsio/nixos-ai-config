{ lib, utils ? import ../lib { inherit lib; }
, moduleUtils ? import ../lib/module-utils.nix { inherit lib; }, ... }:

moduleUtils.createModuleSystem {
  moduleType = "home";
  modulesPath = ./.;
  mkModuleFunc = utils.mkHomeModule;
}
