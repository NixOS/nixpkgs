{ lib, fetchFromGitHub, python3, pkgs }:

python3.pkgs.buildPythonPackage rec {
  pname = "map-machine";
  version = "unstable-2022-10-26";

  src = fetchFromGitHub {
    owner = "enzet";
    repo = pname;
    rev = "dcf3ffa00902d7812dd581c959e97d8d33f3a78d";
    sha512 = "sha512-VtdsI6ATIWoksLzUQGEVlcIjQ9ADrBQwfmUPPHI/DHRcC8yKKiiiKuSxF5mOphKIyWVCL065iMdnzRCccI8QLg==";
  };

  doCheck = false; # Checks require moire, which is not available

  buildInputs = with python3.pkgs; [ pytest ];

  propagatedBuildInputs = with python3.pkgs; [ cairosvg colour numpy pillow pycairo pyyaml setuptools shapely svgwrite urllib3 portolan ];

  postFixup = ''
    patchPythonScript "$out/bin/.map-machine-wrapped"
  '';

  meta = with lib; {
    description = "Python renderer for OpenStreetMap with custom icons intended to display as many map features as possible";
    homepage = "https://github.com/enzet/map-machine";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ kevink ];
  };
}
