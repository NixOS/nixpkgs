{ stdenv, rustPlatform, fetchFromGitHub, installShellFiles, python3, libxcb, AppKit }:

rustPlatform.buildRustPackage rec {
  pname = "kbs2";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "woodruffw";
    repo = pname;
    rev = "v${version}";
    sha256 = "0761g8cl9v7jj444vp83zq9f1shrddqq20pd41d5mbl6f8qpk4m5";
  };

  cargoSha256 = "0vzjkw1g6saz4nwy823dpip02jg2f21rsd8kkpra206b8i6q0mfg";

  nativeBuildInputs = [ installShellFiles ]
    ++ stdenv.lib.optionals stdenv.isLinux [ python3 ];

  buildInputs = [ ]
    ++ stdenv.lib.optionals stdenv.isLinux [ libxcb ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ AppKit ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  checkFlagsArray = [ "--skip=kbs2::config::tests::test_find_config_dir" ];

  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/kbs2 --completions $shell > kbs2.$shell
      installShellCompletion kbs2.$shell
    done
  '';

  meta = with stdenv.lib; {
    description = "A secret manager backed by age";
    homepage = "https://github.com/woodruffw/kbs2";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
