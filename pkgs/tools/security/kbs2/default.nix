{ lib, stdenv, rustPlatform, fetchFromGitHub, installShellFiles, python3, libxcb, AppKit }:

rustPlatform.buildRustPackage rec {
  pname = "kbs2";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "woodruffw";
    repo = pname;
    rev = "v${version}";
    sha256 = "1jilsczz22fyqbgz43gl5ilz62gfqsahfk30gayj7q5bx9k35m4w";
  };

  cargoSha256 = "1gm62c0lr7gahy3ykliqzm9r2d27df0asd2ijqqhifhf0q469f17";

  nativeBuildInputs = [ installShellFiles ]
    ++ lib.optionals stdenv.isLinux [ python3 ];

  buildInputs = [ ]
    ++ lib.optionals stdenv.isLinux [ libxcb ]
    ++ lib.optionals stdenv.isDarwin [ AppKit ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  checkFlags = [ "--skip=kbs2::config::tests::test_find_config_dir" ]
    ++ lib.optionals stdenv.isDarwin [ "--skip=test_ragelib_rewrap_keyfile" ];

  postInstall = ''
    mkdir -p $out/share/kbs2
    cp -r contrib/ $out/share/kbs2
    for shell in bash fish zsh; do
      $out/bin/kbs2 --completions $shell > kbs2.$shell
      installShellCompletion kbs2.$shell
    done
  '';

  meta = with lib; {
    description = "A secret manager backed by age";
    homepage = "https://github.com/woodruffw/kbs2";
    changelog = "https://github.com/woodruffw/kbs2/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
