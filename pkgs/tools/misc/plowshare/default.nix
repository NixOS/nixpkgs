{ stdenv, fetchurl, bash }:

let

  v  = "20120807";

in stdenv.mkDerivation {

  name = "plowshare-git${v}";

  src = fetchurl {
    url = "http://plowshare.googlecode.com/files/plowshare-snapshot-git${v}.tar.gz";
    sha256 = "0clryfssaa4rjvsy760p51ppq1275lwvhm9jh3g4mi973xv4n8si";
  };

  phases = [ "unpackPhase" "installPhase" "postInstallPhase" ];

  installPhase = ''make PREFIX="$out" install'';

  postInstallPhase = ''
    find "$out" -name "*.sh" -exec \
        sed -i "s@#!/bin/bash@#!${bash}/bin/bash@" '{}' \;
  '';

  meta = {
    description = ''
      A command-line download/upload tool for popular file sharing websites
    '';
    license = stdenv.lib.licenses.gpl3;
  };
}
