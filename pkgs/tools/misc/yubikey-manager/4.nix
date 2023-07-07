{ python3Packages, fetchFromGitHub, lib, installShellFiles, yubikey-personalization, libu2f-host, libusb1, procps
, stdenv, pyOpenSSLSupport ? !(stdenv.isDarwin && stdenv.isAarch64) }:

python3Packages.buildPythonPackage rec {
  pname = "yubikey-manager";
  version = "4.0.9";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Yubico";
    repo = "yubikey-manager";
    rev = "refs/tags/${version}";
    sha256 = "sha256-MwM/b1QP6pkyBjz/r6oC4sW1mKC0CKMay45a0wCktk0=";
  };

  patches = lib.optionals (!pyOpenSSLSupport) [
    ./remove-pyopenssl-tests.patch
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'cryptography = ">=2.1, <39"' 'cryptography = ">=2.1"'
    substituteInPlace "ykman/pcsc/__init__.py" \
      --replace 'pkill' '${if stdenv.isLinux then "${procps}" else "/usr"}/bin/pkill'
  '';

  nativeBuildInputs = [ installShellFiles ]
    ++ (with python3Packages; [ poetry-core ]);

  propagatedBuildInputs = with python3Packages; ([
    click
    cryptography
    pyscard
    pyusb
    six
    fido2
  ] ++ lib.optionals pyOpenSSLSupport [
    pyopenssl
  ]) ++ [
    libu2f-host
    libusb1
    yubikey-personalization
  ];

  makeWrapperArgs = [
    "--prefix" "LD_LIBRARY_PATH" ":"
    (lib.makeLibraryPath [ libu2f-host libusb1 yubikey-personalization ])
  ];

  postInstall = ''
    installManPage man/ykman.1

    mkdir -p $out/share/bash-completion/completions
    _YKMAN_COMPLETE=source $out/bin/ykman > $out/share/bash-completion/completions/ykman || :
    mkdir -p $out/share/zsh/site-functions/
    _YKMAN_COMPLETE=source_zsh "$out/bin/ykman" > "$out/share/zsh/site-functions/_ykman" || :
    substituteInPlace "$out/share/zsh/site-functions/_ykman" \
      --replace 'compdef _ykman_completion ykman;' '_ykman_completion "$@"'
  '';

  nativeCheckInputs = with python3Packages; [ pytestCheckHook makefun ];

  meta = with lib; {
    homepage = "https://developers.yubico.com/yubikey-manager";
    description = "Previous release of command line tool for configuring any YubiKey over all USB transports";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ benley lassulus pinpox ];
    mainProgram = "ykman";
  };
}
