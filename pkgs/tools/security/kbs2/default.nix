{ stdenv, rustPlatform, fetchFromGitHub, installShellFiles, python3, libxcb, AppKit }:

rustPlatform.buildRustPackage rec {
  pname = "kbs2";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "woodruffw";
    repo = pname;
    rev = "v${version}";
    sha256 = "1qf17ga5k1shim6lk5lqp6my90gj6qldc36f6l4634kndiv2xflb";
  };

  cargoSha256 = "03nilfc0wvzhvx48m0qj05dqb18ypgkpkmbfj5nb96nridizwg0r";

  nativeBuildInputs = [ installShellFiles ]
    ++ stdenv.lib.optionals stdenv.isLinux [ python3 ];

  buildInputs = [ ]
    ++ stdenv.lib.optionals stdenv.isLinux [ libxcb ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ AppKit ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  checkFlags = [ "--skip=kbs2::config::tests::test_find_config_dir" ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ "--skip=test_ragelib_rewrap_keyfile" ];

  postInstall = ''
    mkdir -p $out/share/kbs2
    cp -r contrib/ $out/share/kbs2
    for shell in bash fish zsh; do
      $out/bin/kbs2 --completions $shell > kbs2.$shell
      installShellCompletion kbs2.$shell
    done
  '';

  meta = with stdenv.lib; {
    description = "A secret manager backed by age";
    homepage = "https://github.com/woodruffw/kbs2";
    changelog = "https://github.com/woodruffw/kbs2/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
