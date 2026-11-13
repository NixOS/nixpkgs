{
  lib,
  mkDerivation,
  nvidia-driver,
  nvidia-libs,
  autoPatchelfHook,
}:
mkDerivation {
  path = "...";
  pname = "nvidia-nvml";
  inherit (nvidia-driver) src version;

  extraNativeBuildInputs = [
    autoPatchelfHook
  ];

  runtimeDependencies = [ nvidia-libs ];
  buildInputs = [ nvidia-libs ];

  env.LOCALBASE = "${builtins.placeholder "out"}";

  dontBuild = true;
  installPhase = ''
    mkdir -p $out/bin
    make -C nvml install
  '';

  meta.platforms = [ "x86_64-freebsd" ];
  meta.license = lib.licenses.unfree;
}
