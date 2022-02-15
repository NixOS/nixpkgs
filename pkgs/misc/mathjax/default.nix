{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec{
  pname = "mathjax";
  version = "3.2.0";
  src = fetchFromGitHub {
    rev = version;
    owner = pname;
    repo = "MathJax";
    hash = "sha256-sFWdSVktoDBiOgvWv8fZol2GGXbORjf6ieNmd5u/o0g=";
  };

  dontBuild = true;
  installPhase = ''
    mkdir -p $out/share
    mv es5 $out/share/$pname
  '';

  meta = with lib; {
    description = "Beautiful and accessible math in all browsers";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = [ maintainers.pasqui23 ];
  };
}
