{stdenv, fetchurl, kdelibs, qt, x11, zlib, perl, libpng}:

stdenv.mkDerivation {
  name = "filelight-1.0";

  src = fetchurl {
    url = http://www.methylblue.com/filelight/packages/filelight-1.0.tar.bz2;
    sha256 = "1mj5q8i818b6qlmjgfk984agp9n72pxi7p7caixzmcm1c2gd8hq7";
  };

  buildInputs = [kdelibs qt x11 zlib perl libpng];
  
  configureFlags = "--without-debug --without-arts";
  
  preConfigure = ''
    sed -e 's/.*sys_lib_\(dl\)\{0,1\}search_path_spec=.*/:/' -i configure
    sed -e '/X_LDFLAGS=/d' -i configure
  '';

  meta = {
    description = "A tool for analysing which directories and files eat your disk space";
  };
}
