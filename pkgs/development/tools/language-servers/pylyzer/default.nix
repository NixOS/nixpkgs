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
  version = "0.0.49";

  src = fetchFromGitHub {
    owner = "mtshiba";
    repo = "pylyzer";
    rev = "v${version}";
    hash = "sha256-1BExqeIL6jaonJVB3aRYDDHRw7xdxHoouH5BlooJDW8=";
  };

  cargoHash = "sha256-HBRczmEqqH+lMgnHeP/WpqHD05tkovJmR12hXwCrw8k=";

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
