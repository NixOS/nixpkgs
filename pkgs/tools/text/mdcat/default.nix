{
  lib,
  curl,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  asciidoctor,
  openssl,
  ansi2html,
  less,
  installShellFiles,
  makeWrapper,
  fzf,
  less,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdcat";
  version = "2.18.0";

  src = fetchFromGitHub {
    owner = "BIRSAx2";
    repo = "mdcat";
    rev = "mdcat-${version}";
    hash = "sha256-wCWyOSiKvKEJltswRoZuzo+6Pfs+dS4V7uCCXukB7aE=";
  };

  nativeBuildInputs = [
    pkg-config
    asciidoctor
    installShellFiles
    makeWrapper
  ];
  buildInputs = [
    curl
    openssl
  ];

  cargoHash = "sha256-ujwqV0LSHxW9lWigHr7B6CeSL3PAVWgc2g4ZggNpHJg=";

  nativeCheckInputs = [
    ansi2html
    # mdpick test pipes through `less -r`
    # Upstream fix: https://github.com/BIRSAx2/mdcat/pull/54
    # Can be removed when upstream is merged and released
    less
  ];

  postInstall = ''
    installManPage $releaseDir/build/mdcat-*/out/mdcat.1
    ln -sr $out/bin/{mdcat,mdless}
    ln -sr $out/bin/{mdcat,mdpick}
    wrapProgram $out/bin/mdpick --suffix PATH : ${lib.makeBinPath [ fzf ]}
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for bin in mdcat mdless mdpick; do
      installShellCompletion --cmd $bin \
        --bash <($out/bin/$bin --completions bash) \
        --fish <($out/bin/$bin --completions fish) \
        --zsh <($out/bin/$bin --completions zsh)
    done
  '';

  meta = {
    description = "cat for markdown";
    homepage = "https://github.com/BIRSAx2/mdcat";
    changelog = "https://github.com/BIRSAx2/mdcat/releases/tag/mdcat-${version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      SuperSandro2000
      giomf
    ];
  };
}
