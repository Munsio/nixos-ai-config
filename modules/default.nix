{ lib, utils ? import ../lib { inherit lib; }
, moduleUtils ? import ../lib/module-utils.nix { inherit lib; }, ... }:

moduleUtils.createModuleSystem {
  moduleType = "nix";
  modulesPath = ./.;
  mkModuleFunc = utils.mkModule;
}
