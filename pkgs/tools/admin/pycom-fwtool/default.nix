{ stdenvNoCC, lib, zlib, libxcb, fetchurl, autoPatchelfHook, buildFHSUserEnv }:

let
  version = "1.16.5";

  # Unwrapped package, for putting into the FHS env
  pycom-fwtool-unwrapped = stdenvNoCC.mkDerivation {
    pname = "pycom-fwtool-unwrapped";
    inherit version;

    src = fetchurl {
      url = "https://software.pycom.io/downloads/pycom_firmware_update_${version}-amd64.tar.gz";
      sha256 = "sha256-AsGblyB+9YU37NiA1Dd83Hhp/9nKZNw5VKy3Jv3RPU4=";
    };

    sourceRoot = "pyupgrade";

    buildInputs = [ zlib ];

    nativeBuildInputs = [ autoPatchelfHook ];

    installPhase = ''
      mkdir -p $out/bin
      install -m755 -D pycom-fwtool $out/bin
      install -m755 -D pycom-fwtool-cli $out/bin
    '';
  };

  # FHS env, since the binary looks for libxcb with dlopen(), and sources can't
  # be patched
  env = buildFHSUserEnv {
    name = "pycom-fwtool-env-${version}";
    targetPkgs = _: [ pycom-fwtool-unwrapped libxcb ];
    runScript = "pycom-fwtool";
  };

in stdenvNoCC.mkDerivation {
  pname = "pycom-fwtool";
  inherit version;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    ln -s ${env}/bin/* $out/bin/pycom-fwtool
    ln -s ${pycom-fwtool-unwrapped}/bin/pycom-fwtool-cli $out/bin/pycom-fwtool-cli
  '';

  meta = with lib; {
    homepage = "https://software.pycom.io/";
    platforms = [ "x86_64-linux" ];
    description = "A tool for updating your Pycom device with the specified firmware image file";
    license = licenses.unfree;
    maintainers = with maintainers; [ matthewcroughan ];
  };
}
