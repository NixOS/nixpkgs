{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "nix-template";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "jonringer";
    repo = pname;
    rev = "v${version}";
    sha256 = "1h6xdvhzg7nb0s82b3r5bsh8bfdb1l5sm7fa24lfwd396xp9yyig";
  };

  cargoSha256 = "1mgvf91cy1w3di05cixk7fpsff41113h3mqpml1c4m6z71qyiryf";

  meta = with lib; {
    description = "Make creating nix expressions easy";
    homepage = "https://github.com/jonringer/nix-template/";
    changelog = "https://github.com/jonringer/nix-template/releases/tag/v${version}";
    license = licenses.cc0;
    maintainers = with maintainers; [ jonringer ];
  };
}
