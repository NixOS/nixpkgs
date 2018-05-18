{ stdenv, fetchurl, perl, libunwind, buildPackages }:

stdenv.mkDerivation rec {
  name = "strace-${version}";
  version = "4.22";

  src = fetchurl {
    url = "https://strace.io/files/${version}/${name}.tar.xz";
    sha256 = "17dkpnsjxmys1ydidm9wcvc3wscsz44fmlxw3dclspn9cj9d1306";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ perl ];

  buildInputs = stdenv.lib.optional libunwind.supportsHost [ libunwind ]; # support -k

  configureFlags = stdenv.lib.optional (stdenv.hostPlatform.isAarch64 || stdenv.hostPlatform.isRiscV) "--enable-mpers=check";

  meta = with stdenv.lib; {
    homepage = http://strace.io/;
    description = "A system call tracer for Linux";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jgeerds globin ];
  };
}
