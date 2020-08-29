{ stdenv, rustPlatform, fetchFromGitHub, installShellFiles, python3, libxcb, AppKit }:

rustPlatform.buildRustPackage rec {
  pname = "kbs2";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "woodruffw";
    repo = pname;
    rev = "v${version}";
    sha256 = "1hjcx651nqj1plxw4i2nv72zc0igd8pl31dy2zwm5yyky6dl7qla";
  };

  cargoSha256 = "11fw097r4mim3rgb0db7naqlf3ws0bavqdd4z84mpdg6714dga0n";

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
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
