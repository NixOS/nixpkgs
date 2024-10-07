{ stdenv, fetchurl, lib, unzip }:
let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  plat = {
    x86_64-linux = "linux_x86_64";
    x86_64-darwin = "mac_universal";
    aarch64-linux = "linux_aarch64";
    aarch64-darwin = "mac_universal";
  }.${system} or throwSystem;

  sha256 = {
    x86_64-linux = "0iqmgvbjpsls28ky1r3milzy44jjz7hf70b0vvhby5xnwbc38bx2";
    x86_64-darwin = "1w2bhsh8q9yqbp4y9a1g3rzf9b5nby42qas2531pkf1jzl06di44";
    aarch64-linux = "0vj8wv8plm1pj10p2p1g5g50h9l7i5qzag5n3frgpsaz4dd53rkj";
    aarch64-darwin = "1w2bhsh8q9yqbp4y9a1g3rzf9b5nby42qas2531pkf1jzl06di44";
  }.${system} or throwSystem;
in
  stdenv.mkDerivation rec {
    pname = "mirrord";
    version = "3.100.1";

    src = fetchurl {
      url = "https://github.com/metalbear-co/${pname}/releases/download/${version}/${pname}_${plat}.zip";
      inherit sha256;
    };

    nativeBuildInputs = [ unzip ];
    dontBuild = true;
    dontConfigure = true;
    noDumpEnvVars = true;

    unpackPhase = ''
      mkdir -p $out/unpacked
      unzip $src -d $out/unpacked
    '';

    installPhase = ''
      mkdir -p $out/bin
      mv $out/unpacked/* $out/bin/
      chmod +x $out/bin/*
    '';

    meta = {
      description = "mirrord lets developers run local processes in the context of their Kubernetes environment";
      homepage = "https://github.com/metalbear-co/mirrord";
      license = lib.licenses.mit;
      platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
    };
  }
