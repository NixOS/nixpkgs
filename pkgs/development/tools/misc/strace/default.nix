{ stdenv, fetchurl, perl, libunwind, buildPackages }:

stdenv.mkDerivation rec {
  name = "strace-${version}";
  version = "5.1";

  src = fetchurl {
    url = "https://strace.io/files/${version}/${name}.tar.xz";
    sha256 = "12wsga1v3rab24gr0mpfip7j7gwr90m8f9h6fviqxa3xgnwl38zm";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ perl ];

  buildInputs = stdenv.lib.optional libunwind.supportsHost libunwind; # support -k

  configureFlags = stdenv.lib.optional (!stdenv.hostPlatform.isx86) "--enable-mpers=check";

  # fails 1 out of 523 tests with
  # "strace-k.test: failed test: ../../strace -e getpid -k ../stack-fcall output mismatch"
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://strace.io/;
    description = "A system call tracer for Linux";
    license =  with licenses; [ lgpl21Plus gpl2Plus ]; # gpl2Plus is for the test suite
    platforms = platforms.linux;
    maintainers = with maintainers; [ globin ];
  };
}
