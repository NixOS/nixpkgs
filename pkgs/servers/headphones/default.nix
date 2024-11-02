{ lib, fetchFromGitHub, python3, makeWrapper }:

python3.pkgs.buildPythonApplication rec {
  pname = "headphones";
  version = "0.6.3";
  format = "other";

  src = fetchFromGitHub {
    owner = "rembo10";
    repo = "headphones";
    rev = "v${version}";
    sha256 = "195v0ylhqd49bqq3dpig5nh0kivmwgmn0977fknix9j14jpvmd3b";
  };

  dontBuild = true;
  doCheck = false;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/opt/headphones
    cp -R {data,headphones,lib,Headphones.py} $out/opt/headphones

    echo v${version} > $out/opt/headphones/version.txt

    makeWrapper $out/opt/headphones/Headphones.py $out/bin/headphones

    runHook postInstall
  '';

  meta = with lib; {
    description = "Automatic music downloader for SABnzbd";
    license     = licenses.gpl3Plus;
    homepage    = "https://github.com/rembo10/headphones";
    maintainers = with lib.maintainers; [ rembo10 ];
    mainProgram = "headphones";
  };
}
