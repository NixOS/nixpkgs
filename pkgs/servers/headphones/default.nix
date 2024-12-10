{
  lib,
  fetchFromGitHub,
  python3,
  makeWrapper,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "headphones";
  version = "0.6.1";
  format = "other";

  src = fetchFromGitHub {
    owner = "rembo10";
    repo = "headphones";
    rev = "v${version}";
    sha256 = "1pj6xrcc6g336lb2knlc9l3qxgj3jaaymnbd7bmfjahgq5cp4d4v";
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
    license = licenses.gpl3Plus;
    homepage = "https://github.com/rembo10/headphones";
    maintainers = with lib.maintainers; [ rembo10 ];
    mainProgram = "headphones";
  };
}
