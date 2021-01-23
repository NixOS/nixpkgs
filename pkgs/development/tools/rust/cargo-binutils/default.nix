{ stdenv, lib, fetchFromGitHub, rustPlatform, runCommand }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-binutils";
  version = "0.3.3";

  # Upstream doesn't commit `Cargo.lock`, see https://github.com/rust-embedded/cargo-binutils/pull/99
  src = let
    repo = fetchFromGitHub {
      owner = "rust-embedded";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-Dgn+f4aSsDSh+RC8yvt3ydkdtwib5jEVsnZkod5c7Vo=";
    };
  in runCommand "source" { } ''
    cp -R ${repo} $out
    chmod -R +w $out
    cp ${./Cargo.lock} $out/Cargo.lock
  '';

  cargoSha256 = "sha256-Zrl269PacPi81TrGTIDzmVndgGY5i5lYyspiOj43rpw=";

  meta = with lib; {
    description = "Cargo subcommands to invoke the LLVM tools shipped with the Rust toolchain";
    homepage = "https://github.com/rust-embedded/cargo-binutils";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ stupremee ];
  };
}
