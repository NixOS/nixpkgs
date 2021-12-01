{ lib, stdenv, rustPlatform, fetchFromGitHub, installShellFiles, python3, libxcb, AppKit, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "kbs2";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "woodruffw";
    repo = pname;
    rev = "v${version}";
    sha256 = "1bipphrzfz4dfzaqn1q60qazs7ylcx0b34gyl4q6d6jivsrhi8a4";
  };

  cargoSha256 = "0r254k85hqf2v8kdhwld8k7b350qjvkwfw2v22ikk2b41b2g4gbw";

  nativeBuildInputs = [ installShellFiles ]
    ++ lib.optionals stdenv.isLinux [ python3 ];

  buildInputs = [ ]
    ++ lib.optionals stdenv.isLinux [ libxcb ]
    ++ lib.optionals stdenv.isDarwin [ AppKit libiconv ];

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
