{ lib, fetchFromGitHub, python3, makeWrapper }:

python3.pkgs.buildPythonApplication rec {
  pname = "headphones";
  version = "0.6.0-alpha.1";

  src = fetchFromGitHub {
    owner = "rembo10";
    repo = "headphones";
    rev = "v${version}";
    sha256 = "sha256-+mWtceQoHSMRkA8izZnKM0cgbt0P5Hr3arKOevpKvqc=";
  };

  dontBuild = true;
  doCheck = false;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin $out/opt/headphones
    cp -R {data,headphones,lib,Headphones.py} $out/opt/headphones

    echo v${version} > $out/opt/headphones/version.txt

    makeWrapper $out/opt/headphones/Headphones.py $out/bin/headphones
  '';

  meta = with lib; {
    description = "Automatic music downloader for SABnzbd";
    license     = licenses.gpl3;
    homepage    = "https://github.com/rembo10/headphones";
    maintainers = with lib.maintainers; [ rembo10 ];
  };
}
