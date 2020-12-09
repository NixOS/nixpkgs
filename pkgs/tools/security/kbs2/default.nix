{ stdenv, rustPlatform, fetchFromGitHub, installShellFiles, python3, libxcb, AppKit }:

rustPlatform.buildRustPackage rec {
  pname = "kbs2";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "woodruffw";
    repo = pname;
    rev = "v${version}";
    sha256 = "15lfl1jp894arcwmbjc81r1zc1ldc84fm2szac6ljg84x772qypd";
  };

  cargoSha256 = "1k2k5dhrdlykha3ax3x9b1zs9aqiiw30gcxg9ainb0123d71njqf";

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
