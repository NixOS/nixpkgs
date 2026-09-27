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
}:

rustPlatform.buildRustPackage rec {
  pname = "mdcat";
  version = "2.17.0";

  src = fetchFromGitHub {
    owner = "BIRSAx2";
    repo = "mdcat";
    rev = "mdcat-${version}";
    hash = "sha256-pBKGxMUZ9U93HmotoItxIitijZ2yMBPduBv5Ul1yQyI=";
  };

  nativeBuildInputs = [
    pkg-config
    asciidoctor
    installShellFiles
  ];
  buildInputs = [
    curl
    openssl
  ];

  cargoHash = "sha256-9/v33gdd9dGCdEDf53u1bKhsQGQXCBrtSe5ZvCGN1LU=";

  nativeCheckInputs = [
    ansi2html
    less
  ];

  postInstall = ''
    installManPage $releaseDir/build/mdcat-*/out/mdcat.1
    ln -sr $out/bin/{mdcat,mdless}
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for bin in mdcat mdless; do
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
