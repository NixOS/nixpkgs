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
  version = "0.47.0";

  src = fetchFromGitHub {
    owner = "starship";
    repo = pname;
    rev = "v${version}";
    sha256 = "0vdfdwsaqrah0hgvr62qsww7s5znb1rg5kk068qpf06lmyc4gd8w";
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

  cargoSha256 = "01brsckfa2zy1aqs9vjwrn4w416i8b621bvkhicanz9q56xlnd77";

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
    maintainers = with maintainers; [ bbigras davidtwco Br1ght0ne Frostman marsam ];
  };
}
