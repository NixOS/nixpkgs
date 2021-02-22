{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "resvg";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "RazrFalcon";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Jo+dx4+3GpEwOoE8HH0YahBmPvT9Oy2qXMvCJ/NZhF0=";
  };

  cargoSha256 = "sha256-8Es9NZYsC/9PZ6ytWZTAH42U3vxZtJERPSsno1s4TEc=";

  doCheck = false;

  meta = with lib; {
    description = "An SVG rendering library";
    homepage = "https://github.com/RazrFalcon/resvg";
    license = licenses.mpl20;
    maintainers = [ maintainers.marsam ];
  };
}
