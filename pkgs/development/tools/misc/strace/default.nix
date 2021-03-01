{ lib, stdenv, fetchurl, perl, libunwind, buildPackages }:

stdenv.mkDerivation rec {
  pname = "strace";
  version = "5.10";

  src = fetchurl {
    url = "https://strace.io/files/${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-/jmC6kzZrrO0ujX2J58LV3o3F10ygr4kuaVTe1a48Bw=";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ perl ];

  buildInputs = [ perl.out ] ++ lib.optional libunwind.supportsHost libunwind; # support -k

  postPatch = "patchShebangs --host strace-graph";

  configureFlags = [ "--enable-mpers=check" ];

  meta = with lib; {
    homepage = "https://strace.io/";
    description = "A system call tracer for Linux";
    license =  with licenses; [ lgpl21Plus gpl2Plus ]; # gpl2Plus is for the test suite
    platforms = platforms.linux;
    maintainers = with maintainers; [ globin ma27 ];
  };
}
