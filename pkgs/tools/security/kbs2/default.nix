{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, installShellFiles
, python3
, libxcb
, AppKit
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "kbs2";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "woodruffw";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-o8/ENAWzVqs7rokST6xnyu9Q/pKqq/UnKWOFRuIuGes=";
  };

  cargoHash = "sha256-LcnvCWGVdBxhDgQDoGHXRppGeEpfjOv/F0dZMN2bOF8=";

  nativeBuildInputs = [ installShellFiles ]
    ++ lib.optionals stdenv.isLinux [ python3 ];

  buildInputs = [ ]
    ++ lib.optionals stdenv.isLinux [ libxcb ]
    ++ lib.optionals stdenv.isDarwin [ SystemConfiguration AppKit ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  checkFlags = [ "--skip=kbs2::config::tests::test_find_config_dir" ]
    ++ lib.optionals stdenv.isDarwin [ "--skip=test_ragelib_rewrap_keyfile" ];

  postInstall = ''
    mkdir -p $out/share/kbs2
    cp -r contrib/ $out/share/kbs2
    installShellCompletion --cmd kbs2 \
      --bash <($out/bin/kbs2 --completions bash) \
      --fish <($out/bin/kbs2 --completions fish) \
      --zsh <($out/bin/kbs2 --completions zsh)
  '';

  meta = with lib; {
    description = "A secret manager backed by age";
    homepage = "https://github.com/woodruffw/kbs2";
    changelog = "https://github.com/woodruffw/kbs2/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
