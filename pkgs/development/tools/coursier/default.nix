{ stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  name = "coursier-${version}";
  version = "1.0.0-RC3";

  src = fetchurl {
    url = "https://github.com/coursier/coursier/raw/v${version}/coursier";
    sha256 = "0iiv79ig8p9pm7fklxskxn6bx1m4xqgdfdk6bvqq81gl8b101z5w";
  };

  nativeBuildInputs = [ makeWrapper ];

  phases = "installPhase";

  installPhase = ''
    mkdir -p $out/bin
    cp ${src} $out/bin/coursier
    chmod +x $out/bin/coursier
    wrapProgram $out/bin/coursier --prefix PATH ":" ${jre}/bin ;
  '';

  meta = with stdenv.lib; {
    homepage = http://get-coursier.io/;
    description = "A Scala library to fetch dependencies from Maven / Ivy repositories";
    license = licenses.asl20;
    maintainers = with maintainers; [ adelbertc nequissimus ];
  };
}
