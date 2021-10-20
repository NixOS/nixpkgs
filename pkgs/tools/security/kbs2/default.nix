{ lib, stdenv, rustPlatform, fetchFromGitHub, installShellFiles, python3, libxcb, AppKit, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "kbs2";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "woodruffw";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Mh56VjFHwjiZ0fvOF3fFw+1IU5HwkRdMlFrt3tZjcZY=";
  };

  cargoSha256 = "sha256-hjUDLA5vNCCIEFQsAhv3hDur1LIGQKYO2rR6AoEb+wA=";

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
