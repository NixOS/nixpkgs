{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, pkg-config
, openssl
, installShellFiles
, libiconv
, nixosTests
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "starship";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "starship";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5MJA8eHo1enOHlLpAOF1iDvOHCS/Nw0sc84VWu9nApE=";
  };

  nativeBuildInputs = [ installShellFiles ] ++ lib.optionals stdenv.isLinux [ pkg-config ];

  buildInputs = lib.optionals stdenv.isLinux [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ libiconv Security ];

  buildFeatures = lib.optional (!stdenv.isDarwin) "notify-rust";

  postInstall = ''
    for shell in bash fish zsh; do
      STARSHIP_CACHE=$TMPDIR $out/bin/starship completions $shell > starship.$shell
      installShellCompletion starship.$shell
    done
  '';

  cargoSha256 = "sha256-DTQQFxj6stzlVzSdmv4J4Nsf8X/VMlwvfIumnuK0YDo=";

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
