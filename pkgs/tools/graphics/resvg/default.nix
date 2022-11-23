{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "resvg";
  version = "0.26.1";

  src = fetchFromGitHub {
    owner = "RazrFalcon";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1UZWX+8hH5DyjFb70wFtnp2RUCmgUKxOGv/yIaLz+30=";
  };

  cargoSha256 = "sha256-b1jDJod/pDmtm2i4YKNTm8to3YIIkbjkVKnE3sG32H4=";

  meta = with lib; {
    description = "An SVG rendering library";
    homepage = "https://github.com/RazrFalcon/resvg";
    changelog = "https://github.com/RazrFalcon/resvg/raw/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = [ maintainers.marsam ];
  };
}
