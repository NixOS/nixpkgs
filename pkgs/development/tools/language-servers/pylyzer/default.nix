{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, git
, python3
, makeWrapper
, writeScriptBin
, darwin
, which
}:

rustPlatform.buildRustPackage rec {
  pname = "pylyzer";
  version = "0.0.51";

  src = fetchFromGitHub {
    owner = "mtshiba";
    repo = "pylyzer";
    rev = "refs/tags/v${version}";
    hash = "sha256-TKAmIy5dP2m1iokxSqfxTj79UDkW00+se/NDGS3euwA=";
  };

  cargoHash = "sha256-035ueF42g6By+6TOGEultc8n350g3mRT00raQgWIcUM=";

  nativeBuildInputs = [
    git
    python3
    makeWrapper
  ] ++ lib.optionals stdenv.isDarwin [
    (writeScriptBin "diskutil" "")
  ];

  buildInputs = [
    python3
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  preBuild = ''
    export HOME=$TMPDIR
  '';

  postInstall = ''
    mkdir -p $out/lib
    cp -r $HOME/.erg/ $out/lib/erg
  '';

  nativeCheckInputs = [
    which
  ];

  checkFlags = [
    # this test causes stack overflow
    # > thread 'exec_import' has overflowed its stack
    "--skip=exec_import"
  ];

  postFixup = ''
    wrapProgram $out/bin/pylyzer --set ERG_PATH $out/lib/erg
  '';

  meta = with lib; {
    description = "A fast static code analyzer & language server for Python";
    homepage = "https://github.com/mtshiba/pylyzer";
    changelog = "https://github.com/mtshiba/pylyzer/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
