{ stdenv, fetchurl, llvmPackages }:

stdenv.mkDerivation rec {
  name    = "musl-${version}";
  version = "1.1.12";

  src = fetchurl {
    url    = "http://www.musl-libc.org/releases/${name}.tar.gz";
    sha256 = "03hwsgq7s5q8ww3yc20mc3yq2pqd6h4rbzmzq1wvdd3nwb3q62vj";
  };

  enableParallelBuilding = true;

  configureFlags = [
    "--enable-shared"
    "--enable-static"
  ];

  dontDisableStatic = true;

  # needed for rustc musl build
  postInstall = "cp ${llvmPackages.libunwind}/lib/libunwind.a $out/lib/";

  meta = {
    description = "An efficient, small, quality libc implementation";
    homepage    = "http://www.musl-libc.org";
    license     = stdenv.lib.licenses.mit;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
