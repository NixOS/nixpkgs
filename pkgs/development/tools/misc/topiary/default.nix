{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "topiary";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "tweag";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Gm6AzzVLUXZi2jzJ1b/c4yjIvRRA2e5mC2CMVyly2X8=";
  };

  cargoSha256 = "sha256-2Ovwntg3aZyR73rg8ruA/U1wVS1BO+B7r37D6/LPa/g=";

  postInstall = ''
    install -Dm444 languages/* -t $out/share/languages
  '';

  TOPIARY_LANGUAGE_DIR = "${placeholder "out"}/share/languages";

  meta = with lib; {
    description = "A uniform formatter for simple languages, as part of the Tree-sitter ecosystem";
    homepage = "https://github.com/tweag/topiary";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
