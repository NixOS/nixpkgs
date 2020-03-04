{ stdenv, fetchurl, zlib, buildFHSUserEnv, ocl-icd }:

let
  pkg = stdenv.mkDerivation rec {
    pname = "folding-at-home";
    version = "7.5.1";

    src = fetchurl {
      url = https://download.foldingathome.org/releases/public/release/fahclient/debian-stable-64bit/v7.5/fahclient_7.5.1_amd64.deb;
      sha256 = "09kxsgs9csizcy3973pvcf9k7nipdjy9hnw1q5cp4ri8sdhp1r7g";
    };

    unpackPhase = "
      ar x $src
      tar xvf data.tar.xz
    ";

    installPhase = ''
      cd usr/bin
      BINFILES="FAHClient FAHCoreWrapper";
      mkdir -p $out/bin
      cp $BINFILES $out/bin
    '';
  };

in

buildFHSUserEnv {
  name = "FAHClient";
  targetPkgs = ps: [pkg zlib ocl-icd];
  runScript = "/bin/FAHClient";
  meta = {
    homepage = http://folding.stanford.edu/;
    description = "Folding@home distributed computing client";
    license = stdenv.lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}

