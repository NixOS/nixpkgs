{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, installShellFiles
, libiconv
, libgit2
, pkg-config
, nixosTests
, Security
, Foundation
}:

rustPlatform.buildRustPackage rec {
  pname = "starship";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "starship";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-mqUE4JzNBhvtDpT2LM23eHX8q93wtPqA+/zr/PxEDiE=";
  };

  nativeBuildInputs = [ installShellFiles pkg-config ];

  buildInputs = [ libgit2 ] ++ lib.optionals stdenv.isDarwin [ libiconv Security Foundation ];

  postInstall = ''
    for shell in bash fish zsh; do
      STARSHIP_CACHE=$TMPDIR $out/bin/starship completions $shell > starship.$shell
      installShellCompletion starship.$shell
    done
  '';

  cargoSha256 = "sha256-hQNDiayVT4UgbxcxdXssi/evPvwgyvG/UOFyEHj7jpo=";

  preCheck = ''
    HOME=$TMPDIR
  '';

  passthru.tests = {
    inherit (nixosTests) starship;
  };

  meta = with lib; {
    description = "A minimal, blazing fast, and extremely customizable prompt for any shell";
    homepage = "https://starship.rs";
    license = licenses.isc;
    maintainers = with maintainers; [ bbigras danth davidtwco Br1ght0ne Frostman marsam ];
  };
}
