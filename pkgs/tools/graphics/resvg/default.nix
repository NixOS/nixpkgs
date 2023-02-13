{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "resvg";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "RazrFalcon";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ppBJx3Yax2w8/D9DQayS+jfqFP1sa9pdVGeAHExg+9Y=";
  };

  cargoHash = "sha256-l/Ytlzyoo27geZZ7wFYHStqD6TvMuI4SC0+DYjTK57w=";

  meta = with lib; {
    description = "An SVG rendering library";
    homepage = "https://github.com/RazrFalcon/resvg";
    changelog = "https://github.com/RazrFalcon/resvg/raw/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = [ maintainers.marsam ];
  };
}
