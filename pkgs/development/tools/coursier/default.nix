{ stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  name    = "coursier-${version}";
  version = "1.0.0-M15-5";

  src = fetchurl {
    url    = "https://github.com/coursier/coursier/raw/v${version}/coursier";
    sha256 = "610c5fc08d0137c5270cefd14623120ab10cd81b9f48e43093893ac8d00484c9";
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
    homepage    = http://get-coursier.io/;
    description = "A Scala library to fetch dependencies from Maven / Ivy repositories";
    license     = licenses.asl20;
    maintainers = with maintainers; [ adelbertc nequissimus ];
  };
}
