{ stdenv, fetchFromGitHub, rustPlatform, pkg-config, openssl, installShellFiles
, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "starship";
  version = "0.42.0";

  src = fetchFromGitHub {
    owner = "starship";
    repo = pname;
    rev = "v${version}";
    sha256 = "17wc9f07308a97dsmrkq74w2r639sqms0hwh8gavwxycj7wq7xz2";
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

  cargoSha256 = "1nvs68qxygi2l43vxw890r40px35dvzbcg6qmrm09g60ykd8pjv2";
  checkPhase = "cargo test -- --skip directory::home_directory --skip directory::directory_in_root";

  meta = with stdenv.lib; {
    description = "A minimal, blazing fast, and extremely customizable prompt for any shell";
    homepage = "https://starship.rs";
    license = licenses.isc;
    maintainers = with maintainers; [ bbigras davidtwco filalex77 Frostman ];
    platforms = platforms.all;
  };
}
