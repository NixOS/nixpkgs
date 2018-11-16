{ stdenv, fetchurl, perl, libunwind, buildPackages }:

stdenv.mkDerivation rec {
  name = "strace-${version}";
  version = "4.25";

  src = fetchurl {
    url = "https://strace.io/files/${version}/${name}.tar.xz";
    sha256 = "00f7zagfh3np5gwi0z7hi7zjd7s5nixcaq7z78n87dvhakkgi1fn";
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
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jgeerds globin ];
  };
}
