{
  lib,
  buildPythonPackage,
  fetchurl,
  pillow,
  svgwrite,
}:

buildPythonPackage rec {
  pname = "pixel2svg";
  version = "0.3.0";
  format = "setuptools";

  src = fetchurl {
    url = "https://static.florian-berger.de/pixel2svg-${version}.zip";
    sha256 = "sha256-aqcTTmZKcdRdVd8GGz5cuaQ4gjPapVJNtiiZu22TZgQ=";
  };

  propagatedBuildInputs = [
    pillow
    svgwrite
  ];

  meta = with lib; {
    homepage = "https://florian-berger.de/en/software/pixel2svg/";
    description = "Converts pixel art to SVG - pixel by pixel";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ annaaurora ];
    mainProgram = "pixel2svg.py";
  };
}
