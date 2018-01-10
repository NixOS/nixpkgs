{ stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  name = "coursier-${version}";
  version = "1.0.0";

  src = fetchurl {
    url = "https://github.com/coursier/coursier/raw/v${version}/coursier";
    sha256 = "0167cgp3kqx336p8dmlxx57bi3lhzyp6ncly28v1s7r2sjxj9krj";
  };

  nativeBuildInputs = [ makeWrapper ];

  unpackPhase = ":";

  installPhase = ''
    mkdir -p $out/bin
    cp ${src} $out/bin/coursier
    chmod +x $out/bin/coursier
    wrapProgram $out/bin/coursier --prefix PATH ":" ${jre}/bin
  '';

  meta = with stdenv.lib; {
    homepage = http://get-coursier.io/;
    description = "A Scala library to fetch dependencies from Maven / Ivy repositories";
    license = licenses.asl20;
    maintainers = with maintainers; [ adelbertc nequissimus ];
  };
}
