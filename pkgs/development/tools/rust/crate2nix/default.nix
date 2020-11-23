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
  version = "0.8.0";

  src = fetchFromGitHub
    {
      owner = "kolloch";
      repo = pname;
      rev = version;
      sha256 = "sha256-pqg1BsEq3kGmUzt1zpQvXgdnRcIsiuIyvtUBi3VxtZ4=";
    } + "/crate2nix";

  cargoSha256 = "sha256-dAMWrGNMleQ3lDbG46Hr4qvCyxR+QcPOUZw9r2/CxV4=";

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
