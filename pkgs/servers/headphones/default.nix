{ stdenv, fetchFromGitHub, python2, makeWrapper }:

python2.pkgs.buildPythonApplication rec {
  name = "headphones-${version}";
  version = "0.5.19";

  src = fetchFromGitHub {
    owner = "rembo10";
    repo = "headphones";
    rev = "v${version}";
    sha256 = "0z39gyan3ksdhnjxxs7byamrzmrk8cn15g300iqigzvgidff1lq0";
  };

  dontBuild = true;
  doCheck = false;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ python2 ];

  installPhase = ''
    mkdir -p $out/bin
    cp -R {data,headphones,lib,Headphones.py} $out/

    makeWrapper $out/Headphones.py $out/bin/headphones
  '';

  meta = with stdenv.lib; {
    description = "Automatic music downloader for SABnzbd";
    license     = licenses.gpl3;
    homepage    = https:/github.com/rembo10/headphones;
    maintainers = with stdenv.lib.maintainers; [ rembo10 ];
  };
}
