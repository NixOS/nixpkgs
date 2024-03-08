{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "lemmy-help";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "numToStr";
    repo = "lemmy-help";
    rev = "v${version}";
    sha256 = "sha256-HcIvHuuzQj4HsRJyn1A9nXiGDGAcz1nqTsC7sROt7OI=";
  };

  buildFeatures = [ "cli" ];

  cargoSha256 = "sha256-BCwpiBPvnLgbpOaXgUK2EDXnT8d4jo7aqgM6uwl80eg=";

  meta = with lib; {
    description = "A CLI for generating vim help docs from emmylua comments";
    longDescription = ''
      `lemmy-help` is an emmylua parser as well as a CLI which takes that parsed tree and converts it into vim help docs.
    '';
    homepage = "https://github.com/numToStr/lemmy-help";
    changelog = "https://github.com/numToStr/lemmy-help/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "lemmy-help";
  };
}
