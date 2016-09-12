{ stdenv, fetchFromGitHub,
  xlibsWrapper, libev, libXi, libXfixes,
  pkgconfig, asciidoc, libxslt, docbook_xsl }:

let version = "1.2"; in

stdenv.mkDerivation {
  name = "unclutter-xfixes-${version}";
  version = version;
  
  src = fetchFromGitHub {
    owner = "Airblader";
    repo = "unclutter-xfixes";
    rev = "v${version}";
    sha256 = "1pw567mj7mq5kr8mqnyrvy7jj62qfg6zgqfyzz21nncslddnjzg8";
  };

  nativeBuildInputs = [pkgconfig];
  buildInputs = [
    xlibsWrapper libev libXi libXfixes
    asciidoc libxslt docbook_xsl
  ];

  postPatch = ''
    substituteInPlace Makefile --replace "CC = gcc" "CC = cc"
  '';

  preBuild = ''
    # The Makefile calls git only to discover the package version,
    # but that doesn't work right in the build environment,
    # so we fake it.
    git() { echo v${version}; }
    export -f git
  '';

  preInstall = ''
    export DESTDIR=$out MANDIR=/man/man1
  '';
  
  postInstall = ''
    mv $out/usr/bin $out/bin
    mv $out/usr/share/man $out/man
  '';

  meta = with stdenv.lib; {
    description = "Rewrite of unclutter using the X11 Xfixes extension";
    platforms = platforms.unix;
    license = stdenv.lib.licenses.mit;
    inherit version;
  };
}
