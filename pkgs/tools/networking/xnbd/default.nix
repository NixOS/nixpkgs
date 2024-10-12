{ lib, stdenv, fetchurl, pkg-config, autoreconfHook, glib, jansson }:

stdenv.mkDerivation rec {
  pname = "xnbd";
  version = "0.4.0";

  src = fetchurl {
    url = "https://bitbucket.org/hirofuchi/xnbd/downloads/xnbd-${version}.tgz";
    sha256 = "00wkvsa0yaq4mabczcbfpj6rjvp02yahw8vdrq8hgb3wpm80x913";
  };

  sourceRoot = "xnbd-${version}/trunk";

  patches = [ ./0001-Fix-build-for-glibc-2.28.patch ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ glib jansson ];

  # do not build docs, it is slow and it fails on Hydra
  prePatch = ''
    rm -rf doc
    substituteInPlace configure.ac --replace "doc/Makefile" ""
    substituteInPlace Makefile.am --replace "lib doc ." "lib ."
  '';

  meta = {
    homepage = "https://bitbucket.org/hirofuchi/xnbd";
    description = "Yet another NBD (Network Block Device) server program";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
