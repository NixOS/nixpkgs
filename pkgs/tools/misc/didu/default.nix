{ lib, rustPlatform, fetchFromGitea }:

rustPlatform.buildRustPackage rec {
  pname = "didu";
  version = "2.5.2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "annaaurora";
    repo = pname;
    rev = "v${version}";
    sha256 = "szYWRN1NZbfpshipwMMJSWJw/NG4w7I+aqwtmqpT0R0=";
  };

  cargoHash = "sha256-O1kkfrwv7xiOh3wCV/ce6cqpkMPRRzcXOFESYMAhiKA=";

  meta = with lib; {
    description = "Duration conversion between units";
    homepage = "https://codeberg.org/annaaurora/didu";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ annaaurora ];
    mainProgram = "didu";
  };
}
