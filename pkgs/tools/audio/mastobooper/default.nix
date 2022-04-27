{ lib, rustPlatform, fetchFromGitHub, pkg-config, alsaLib }:

rustPlatform.buildRustPackage rec {
  pname = "mastobooper";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "ckiee";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-EA+5aEcME0uhMFAINmDZTZ786QywZKCdtXZzg/lo3JQ=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ alsaLib ];

  cargoSha256 = "sha256-HLXoJo96zkUWi6gbM6zezuGbmiftiSii9gZ5pUBDoGQ=";

  meta = with lib; {
    description =
      "Occasionally play a bunch of different mastoboops from all directions";
    homepage = "https://github.com/ckiee/mastobooper";
    license = licenses.unlicense;
    maintainers = with maintainers; [ ckie ];
  };
}
