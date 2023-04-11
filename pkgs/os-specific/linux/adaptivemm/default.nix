{ lib, stdenv, fetchFromGitHub }:

let
  pname = "adaptivemm";
in stdenv.mkDerivation {
  inherit pname;
  version = "unstable-2023-01-16";

  src = fetchFromGitHub {
    owner = "oracle";
    repo = pname;
    rev = "92f7d6e9155e153db884ebb7da25c0a9cbcb29fe";
    hash = "sha256-3aRfHn0HV9CfcLulDimHsMJPs8/VAWRVDxPijKVhtDM=";
  };

  CFLAGS = "-I. -Wall -O2";

  installPhase = ''
    mkdir -p $out/bin $out/etc/sysconfig $out/share/man/man8
    cp adaptivemmd $out/bin/
    cp $src/adaptivemmd.cfg $out/etc/sysconfig/adaptivemmd
    cp $src/adaptivemmd.8 $out/share/man/man8/
  '';

  meta = with lib; {
    description = "A userspace daemon for proactive free memory management";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cmm ];
  };
}
