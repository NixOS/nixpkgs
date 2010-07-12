{stdenv, fetchurl, libX11, libXext, gettext, libICE, libXtst, libXi, libSM}:

stdenv.mkDerivation {
  name = "tigervnc-1.0.1";
  src = fetchurl {
    url = mirror://sourceforge/tigervnc/tigervnc-1.0.1.tar.gz;
    sha256 = "06qxavpq6d71ca224yxvr9h5ynydqhaz2nf06ajin5kjjdliphsr";
  };

  preConfigure = ''
    cd unix
  '';

  configureFlags = "--enable-nls";

  buildInputs = [ libX11 libXext gettext libICE libXtst libXi libSM ];
}
