{ lib, fetchFromGitHub, python2, makeWrapper }:

python2.pkgs.buildPythonApplication rec {
  pname = "headphones";
  version = "0.5.20";

  src = fetchFromGitHub {
    owner = "rembo10";
    repo = "headphones";
    rev = "v${version}";
    sha256 = "0m234fr1i8bb8mgmjsdpkbaa3l16y23ca6s7nyyl5ismmjxhi4mz";
  };

  dontBuild = true;
  doCheck = false;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ python2 ];

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
