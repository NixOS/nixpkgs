{ stdenv, fetchFromGitHub, rustPlatform, pkg-config, openssl, installShellFiles
, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "starship";
  version = "0.44.0";

  src = fetchFromGitHub {
    owner = "starship";
    repo = pname;
    rev = "v${version}";
    sha256 = "1pxrg5sfqqkvqww3fabq64j1fg03v5fj5yvm2xg2qa5n2f2qwnhi";
  };

  nativeBuildInputs = [ installShellFiles ] ++ stdenv.lib.optionals stdenv.isLinux [ pkg-config ];

  buildInputs = stdenv.lib.optionals stdenv.isLinux [ openssl ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ libiconv Security ];

  postPatch = ''
    substituteInPlace src/utils.rs \
      --replace "/bin/echo" "echo"
  '';

  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/starship completions $shell > starship.$shell
      installShellCompletion starship.$shell
    done
  '';

  cargoSha256 = "1b5gsw7jpiqjc7kbwf2kp6h6ks7jcgygrwzvn2akz86z40sskyg3";

  preCheck = ''
    substituteInPlace tests/testsuite/common.rs \
      --replace "./target/debug/starship" "./$releaseDir/starship"
    substituteInPlace tests/testsuite/python.rs \
      --replace "#[test]" "#[test] #[ignore]"
  '';

  checkFlagsArray = [ "--skip=directory::home_directory" "--skip=directory::directory_in_root" ];

  meta = with stdenv.lib; {
    description = "A minimal, blazing fast, and extremely customizable prompt for any shell";
    homepage = "https://starship.rs";
    license = licenses.isc;
    maintainers = with maintainers; [ bbigras davidtwco filalex77 Frostman marsam ];
    platforms = platforms.all;
  };
}
