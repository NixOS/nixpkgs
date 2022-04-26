{ lib, buildPythonPackage, fetchFromGitHub, python310Packages }:

python310Packages.buildPythonPackage rec {
  pname = "pixel2svg";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "cyChop";
    repo = "pixel2svg-fork";
    rev = "7eb24d3978675c9998c0a8cd3c7cba3e363b98a2";
    sha256 = "sha256-ZuQ0cgjaunzAjVS23PapBLgCpflU7Qnd7dTVJX9v0fg=";
  };

  propagatedBuildInputs = with python310Packages; [ pillow svgwrite ];

  meta = with lib; {
    homepage = "https://florian-berger.de/en/software/pixel2svg/";
    description = "Converts pixel art to SVG - pixel by pixel";
    license = licenses.gpl3Plus;
    platform = platforms.all;
    maintainers = with maintainers; [ papojari ];
  };
}
