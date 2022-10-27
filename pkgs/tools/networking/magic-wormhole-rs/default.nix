{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, libxcb
, Security
, AppKit
}:
rustPlatform.buildRustPackage rec {
  pname = "magic-wormhole-rs";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "magic-wormhole";
    repo = "magic-wormhole.rs";
    rev = version;
    sha256 = "sha256-+H/IzMxiGz7UVVkEWpmyBepGET9doQFNDvOCZEMF0p4=";
  };

  cargoSha256 = "sha256-pRdb5NSqueHmK5vbZfmbDGOz7NQvmUI/pj9KgShiIn0=";

  buildInputs = [ libxcb ]
    ++ lib.optionals stdenv.isDarwin [ Security AppKit ];

  # all tests involve networking and are bound fail
  doCheck = false;

  meta = with lib; {
    description = "Rust implementation of Magic Wormhole, with new features and enhancements";
    homepage = "https://github.com/magic-wormhole/magic-wormhole.rs";
    changelog = "https://github.com/magic-wormhole/magic-wormhole.rs/raw/${version}/changelog.md";
    license = licenses.eupl12;
    maintainers = with maintainers; [ zeri piegames ];
    mainProgram = "wormhole-rs";
  };
}
