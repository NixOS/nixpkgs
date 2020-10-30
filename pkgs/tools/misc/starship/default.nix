{ stdenv
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
  version = "0.46.2";

  src = fetchFromGitHub {
    owner = "starship";
    repo = pname;
    rev = "v${version}";
    sha256 = "092nqxl3vdk8k589bv3g05c598k77f4wsxcgymfb1h1fc0lfzqs4";
  };

  nativeBuildInputs = [ installShellFiles ] ++ stdenv.lib.optionals stdenv.isLinux [ pkg-config ];

  buildInputs = stdenv.lib.optionals stdenv.isLinux [ openssl ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ libiconv Security ];

  postInstall = ''
    for shell in bash fish zsh; do
      STARSHIP_CACHE=$TMPDIR $out/bin/starship completions $shell > starship.$shell
      installShellCompletion starship.$shell
    done
  '';

  cargoSha256 = "1smz7084ppz79p8migpy0cqp6azf7sixv9ga65l2f3zfna7kbk78";

  checkFlags = [
    "--skip=directory_in_home"
    "--skip=home_directory"
    "--skip=directory_in_root"
    "--skip=truncation_symbol_not_truncated_home"
    "--skip=truncation_symbol_truncated_home"
    "--skip=folder_with_glide_yaml"
    "--skip=shows_multiple_tfms"
    "--skip=shows_pinned_in_project_below_root_with_global_json"
  ];

  meta = with stdenv.lib; {
    description = "A minimal, blazing fast, and extremely customizable prompt for any shell";
    homepage = "https://starship.rs";
    license = licenses.isc;
    maintainers = with maintainers; [ bbigras davidtwco filalex77 Frostman marsam ];
  };
}
