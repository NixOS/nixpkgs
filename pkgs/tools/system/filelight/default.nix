{stdenv, fetchurl, kdelibs, qt, x11, zlib, perl,
	libpng}:
stdenv.mkDerivation {
  name = "filelight-1.0";

  src = fetchurl {
    url = http://kde-apps.org/content/download.php?content=9887&id=1;
    sha256 = "1mj5q8i818b6qlmjgfk984agp9n72pxi7p7caixzmcm1c2gd8hq7";
    name = "filelight-1.0.tar.bz2";
  };

  buildInputs = [kdelibs qt x11 zlib perl libpng];
  configureFlags = " --without-debug --without-arts ";
  preConfigure = "sed -e '/sys_lib_\(dl\)\{0,1\}search_path_spec=/d' -i configure;
	sed -e '/X_LDFLAGS=/d' -i configure";

  meta = {
    description = "
	Filelight lets you analyze which directories 
	and files eat your disk space.
";
  };
}
