{ lib, python3Packages, fetchFromGitHub, pillow }:

python3Packages.buildPythonApplication rec {
  pname = "epub-thumbnailer";
  version = "unstable-2022-02-10";

  src = fetchFromGitHub {
    owner = "marianosimone";
    repo = pname;
    rev = "486111b27d192c27011229dc696e9179f59b0eab";
    sha256 = "0mv0zd74g4xfi2pvl8k0z6qvf1987lwk47ia8cyr51capk95p4rp";
  };

  # The installer is a simple python script, so no tests nor build steps are necessary
  dontBuild = true;
  doCheck = false;

  propagatedBuildInputs = [ pillow ];

  installPhase = ''
    runHook preInstall

    install -Dm755 src/epub-thumbnailer.py $out/bin/epub-thumbnailer

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/marianosimone/epub-thumbnailer";
    description = "Script to extract the cover of an epub book and create a thumbnail for it";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ atila ];
  };
}
