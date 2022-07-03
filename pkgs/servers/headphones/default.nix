{ lib, fetchFromGitHub, python3, makeWrapper }:

python3.pkgs.buildPythonApplication rec {
  pname = "headphones";
  version = "0.6.0-beta.5";

  src = fetchFromGitHub {
    owner = "rembo10";
    repo = "headphones";
    rev = "v${version}";
    sha256 = "1ddqk5ch1dlh895cm99li4gb4a596mvq3d0gah9vrbn6fyhp3b4v";
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
  };
}
