{ stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  name = "coursier-${version}";
  version = "1.0.1";

  src = fetchurl {
    url = "https://github.com/coursier/coursier/raw/v${version}/coursier";
    sha256 = "1rn1vb33zfl9iy80fhqvi9ykdjxz029nah5yfr5xixcx9al0bai3";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
    install -Dm555 $src $out/bin/coursier
    wrapProgram $out/bin/coursier --prefix PATH ":" ${jre}/bin
  '';

  meta = with stdenv.lib; {
    homepage = http://get-coursier.io/;
    description = "A Scala library to fetch dependencies from Maven / Ivy repositories";
    license = licenses.asl20;
    maintainers = with maintainers; [ adelbertc nequissimus ];
  };
}
