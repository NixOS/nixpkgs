{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, pkg-config
, openssl
, installShellFiles
, libiconv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "starship";
  version = "0.51.0";

  src = fetchFromGitHub {
    owner = "starship";
    repo = pname;
    rev = "v${version}";
    sha256 = "1bmnwvjhw2ba7yqn9if83d57b8qbrbqgy2br8q2drz4ylk0gjirg";
  };

  nativeBuildInputs = [ installShellFiles ] ++ lib.optionals stdenv.isLinux [ pkg-config ];

  buildInputs = lib.optionals stdenv.isLinux [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ libiconv Security ];

  postInstall = ''
    for shell in bash fish zsh; do
      STARSHIP_CACHE=$TMPDIR $out/bin/starship completions $shell > starship.$shell
      installShellCompletion starship.$shell
    done
  '';

  cargoSha256 = "1d4ca8yzx437x53i7z2kddv9db89zy6ywbgl6y1cwwd6wscbrxcq";

  preCheck = ''
    HOME=$TMPDIR
  '';

  meta = with lib; {
    description = "A minimal, blazing fast, and extremely customizable prompt for any shell";
    homepage = "https://starship.rs";
    license = licenses.isc;
    maintainers = with maintainers; [ bbigras davidtwco Br1ght0ne Frostman marsam ];
  };
}
