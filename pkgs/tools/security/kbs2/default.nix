{ stdenv, rustPlatform, fetchFromGitHub, installShellFiles, python3, libxcb, AppKit }:

rustPlatform.buildRustPackage rec {
  pname = "kbs2";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "woodruffw";
    repo = pname;
    rev = "v${version}";
    sha256 = "1zsqc57dvdn6v0xxb0vf78f50p08km983qhlsf79sr73ch0r3nji";
  };

  cargoSha256 = "0hz99s5i60r8c1jgpb7j7z42j8ad4zzi94z2c0aiddq916z0xcsf";

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
