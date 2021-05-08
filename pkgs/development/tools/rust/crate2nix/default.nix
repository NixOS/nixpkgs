{ lib
, rustPlatform
, fetchFromGitHub
, makeWrapper

, cargo
, nix
, nix-prefetch-git
}:

rustPlatform.buildRustPackage rec {
  pname = "crate2nix";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "kolloch";
    repo = pname;
    rev = version;
    sha256 = "sha256-dB8wa3CQFw8ckD420zpBGw4TnsLrHqXf+ff/WuhPsVM=";
  };

  sourceRoot = "source/crate2nix";

  cargoSha256 = "sha256-6V0ifH63/s5XLo4BCexPtvlUH0UQPHFW8YHF8OCH3ik=";

  nativeBuildInputs = [ makeWrapper ];

  # Tests use nix(1), which tries (and fails) to set up /nix/var inside the
  # sandbox
  doCheck = false;

  postFixup = ''
    wrapProgram $out/bin/crate2nix \
        --suffix PATH ":" ${lib.makeBinPath [ cargo nix nix-prefetch-git ]}
  '';

  meta = with lib; {
    description = "A Nix build file generator for Rust crates.";
    longDescription = ''
      Crate2nix generates Nix files from Cargo.toml/lock files
      so that you can build every crate individually in a Nix sandbox.
    '';
    homepage = "https://github.com/kolloch/crate2nix";
    license = licenses.asl20;
    maintainers = with maintainers; [ kolloch andir cole-h ];
    platforms = platforms.all;
  };
}
