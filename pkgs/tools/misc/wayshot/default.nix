{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "wayshot";
  version = "1.1.9";

  src = fetchFromGitHub {
    owner = "waycrate";
    repo = pname;
    rev = version;
    hash = "sha256-4tzL/9p/qBCSWX+O7wZlKi9qb7mIt+hoxcQY7cWlFoU=";
  };

  cargoHash = "sha256-/FAI2VUoyQ1+3CuA7sEpeF5oeJdGB9CRZEp1leLnTh4=";

  meta = with lib; {
    description = "A native, blazing-fast screenshot tool for wlroots based compositors such as sway and river";
    homepage = "https://github.com/waycrate/wayshot";
    license = licenses.bsd2;
    maintainers = [ maintainers.dit7ya ];
    platforms = platforms.linux;
  };
}
