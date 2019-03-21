{ stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  name = "coursier-${version}";
  version = "1.1.0-M10";

  src = fetchurl {
    url = "https://github.com/coursier/coursier/raw/v${version}/coursier";
    sha256 = "14iq0717vdm0mj0196idc724vmxp1y0f3gfn41sbqahfhvcx05y8";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
    install -Dm555 $src $out/bin/coursier
    patchShebangs $out/bin/coursier
    wrapProgram $out/bin/coursier --prefix PATH ":" ${jre}/bin
  '';

  meta = with stdenv.lib; {
    homepage = http://get-coursier.io/;
    description = "A Scala library to fetch dependencies from Maven / Ivy repositories";
    license = licenses.asl20;
    maintainers = with maintainers; [ adelbertc nequissimus ];
  };
}
