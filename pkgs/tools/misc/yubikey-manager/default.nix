{ python3Packages, fetchFromGitHub, lib, yubikey-personalization, libu2f-host, libusb1, procps }:

python3Packages.buildPythonPackage rec {
  pname = "yubikey-manager";
  version = "4.0.8";
  format = "pyproject";

  src = fetchFromGitHub {
    repo = "yubikey-manager";
    rev = version;
    owner = "Yubico";
    sha256 = "sha256-OszXOu/NhoX4WutsT4Z1LsY54KTOWRKt13yDo2fzDbA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'cryptography = "^2.1 || ^3.0"' 'cryptography = "*"'
    substituteInPlace "ykman/pcsc/__init__.py" \
      --replace 'pkill' '${procps}/bin/pkill'
  '';

  nativeBuildInputs = with python3Packages; [ poetry-core ];

  propagatedBuildInputs =
    with python3Packages; [
      click
      cryptography
      pyscard
      pyusb
      pyopenssl
      six
      fido2
    ] ++ [
      libu2f-host
      libusb1
      yubikey-personalization
    ];

  makeWrapperArgs = [
    "--prefix" "LD_LIBRARY_PATH" ":"
    (lib.makeLibraryPath [ libu2f-host libusb1 yubikey-personalization ])
  ];

  postInstall = ''
    mkdir -p "$out/man/man1"
    cp man/ykman.1 "$out/man/man1"

    mkdir -p $out/share/bash-completion/completions
    _YKMAN_COMPLETE=source $out/bin/ykman > $out/share/bash-completion/completions/ykman || :
    mkdir -p $out/share/zsh/site-functions/
    _YKMAN_COMPLETE=source_zsh "$out/bin/ykman" > "$out/share/zsh/site-functions/_ykman" || :
    substituteInPlace "$out/share/zsh/site-functions/_ykman" \
      --replace 'compdef _ykman_completion ykman;' '_ykman_completion "$@"'
  '';

  checkInputs = with python3Packages; [ pytestCheckHook makefun ];

  meta = with lib; {
    homepage = "https://developers.yubico.com/yubikey-manager";
    description = "Command line tool for configuring any YubiKey over all USB transports";

    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ benley lassulus pinpox ];
  };
}
