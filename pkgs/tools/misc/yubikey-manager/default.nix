<<<<<<< HEAD
{ lib
, stdenv
, fetchFromGitHub
, python3Packages
, installShellFiles
, procps
}:

python3Packages.buildPythonPackage rec {
  pname = "yubikey-manager";
  version = "5.2.0";
=======
{ python3Packages, fetchFromGitHub, lib, yubikey-personalization, libu2f-host, libusb1, procps
, stdenv }:

python3Packages.buildPythonPackage rec {
  pname = "yubikey-manager";
  version = "5.1.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Yubico";
    repo = "yubikey-manager";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-33Y2adUuGIDi5gdenkwZJKKKk2NtcHwLzxy1NXhBa9M=";
  };

  postPatch = ''
=======
    hash = "sha256-rF1oOhlZP1EKiqErJ4L/otkoEvW0iA2P4g5MWCKrCO4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'fido2 = ">=0.9, <1.0"' 'fido2 = ">*"'
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    substituteInPlace "ykman/pcsc/__init__.py" \
      --replace 'pkill' '${if stdenv.isLinux then "${procps}" else "/usr"}/bin/pkill'
  '';

<<<<<<< HEAD
  nativeBuildInputs = with python3Packages; [
    poetry-core
    pythonRelaxDepsHook
    installShellFiles
  ];

  propagatedBuildInputs = with python3Packages; [
    cryptography
    pyscard
    fido2
    click
    keyring
  ];

  pythonRelaxDeps = [
    "keyring"
  ];

  postInstall = ''
    installManPage man/ykman.1

    installShellCompletion --cmd ykman \
      --bash <(_YKMAN_COMPLETE=bash_source "$out/bin/ykman") \
      --zsh  <(_YKMAN_COMPLETE=zsh_source  "$out/bin/ykman") \
      --fish <(_YKMAN_COMPLETE=fish_source "$out/bin/ykman") \
  '';

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    makefun
  ];

  meta = with lib; {
    homepage = "https://developers.yubico.com/yubikey-manager";
    changelog = "https://github.com/Yubico/yubikey-manager/releases/tag/${version}";
=======
  nativeBuildInputs = with python3Packages; [ poetry-core ];

  propagatedBuildInputs =
    with python3Packages; [
      click
      cryptography
      pyscard
      pyusb
      six
      fido2
      keyring
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

  nativeCheckInputs = with python3Packages; [ pytestCheckHook makefun ];

  meta = with lib; {
    homepage = "https://developers.yubico.com/yubikey-manager";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Command line tool for configuring any YubiKey over all USB transports";

    license = licenses.bsd2;
    platforms = platforms.unix;
<<<<<<< HEAD
    maintainers = with maintainers; [ benley lassulus pinpox nickcao ];
=======
    maintainers = with maintainers; [ benley lassulus pinpox ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    mainProgram = "ykman";
  };
}
