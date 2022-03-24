{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "epub-thumbnailer";
  version = "486111b";

  src = fetchFromGitHub {
    owner = "marianosimone";
    repo = pname;
    rev = version;
    sha256 = "0mv0zd74g4xfi2pvl8k0z6qvf1987lwk47ia8cyr51capk95p4rp";
  };

  dontBuild = true;
  doCheck = false;

  propagatedBuildInputs = with python3Packages; [ pillow ];

  installPhase = ''
    runHook preInstall

    install -Dm755 src/epub-thumbnailer.py $out/bin/epub-thumbnailer

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/marianosimone/epub-thumbnailer";
    description = "Script to extract the cover of an epub book and create a thumbnail for it";
    license = licenses.unlicense;
    maintainers = with maintainers; [ atila ];
  };
}
