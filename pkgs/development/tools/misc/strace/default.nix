{ stdenv, fetchurl, perl, libunwind, buildPackages }:

stdenv.mkDerivation rec {
  pname = "strace";
  version = "5.5";

  src = fetchurl {
    url = "https://strace.io/files/${version}/${pname}-${version}.tar.xz";
    sha256 = "1zrhpzjlgfwfl8dd53llswmmharm5rbi0zch7lln5sjris69an4z";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ perl ];

  buildInputs = stdenv.lib.optional libunwind.supportsHost libunwind; # support -k

  configureFlags = stdenv.lib.optional (!stdenv.hostPlatform.isx86) "--enable-mpers=check";

  # fails 1 out of 523 tests with
  # "strace-k.test: failed test: ../../strace -e getpid -k ../stack-fcall output mismatch"
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://strace.io/";
    description = "A system call tracer for Linux";
    license =  with licenses; [ lgpl21Plus gpl2Plus ]; # gpl2Plus is for the test suite
    platforms = platforms.linux;
    maintainers = with maintainers; [ globin ];
  };
}
