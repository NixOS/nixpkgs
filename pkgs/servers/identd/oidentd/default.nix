{ stdenv, fetchurl, bison, flex }:

stdenv.mkDerivation rec {
  pname = "oidentd";
  version = "2.4.0";
  nativeBuildInputs = [ bison flex ];

  src = fetchurl {
    url = "https://files.janikrabe.com/pub/oidentd/releases/${version}/${pname}-${version}.tar.gz";
    sha256 = "132bzlbjp437lrlxv5k9aqa1q9w5pghk02rnazg33cw6av00q2li";
  };

  meta = with stdenv.lib; {
    description = "Configurable Ident protocol server";
    homepage = https://oidentd.janikrabe.com/;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
