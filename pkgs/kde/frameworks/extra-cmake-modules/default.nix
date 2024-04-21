{ mkKdeDerivation }:
mkKdeDerivation {
  pname = "extra-cmake-modules";

  outputs = [ "out" ];

  setupHook = ./ecm-hook.sh;
}
