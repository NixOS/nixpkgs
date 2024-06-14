{ lib
, stdenv
, fetchFromGitHub
, python3Packages
, installShellFiles
, procps
}:

python3Packages.buildPythonPackage rec {
  pname = "yubikey-manager";
  version = "5.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Yubico";
    repo = "yubikey-manager";
    rev = version;
    hash = "sha256-Rn3iGiiR48EFVAn9BRQ043L8x7WwH7XnazZlVw50IGU=";
  };

  postPatch = ''
    substituteInPlace "ykman/pcsc/__init__.py" \
      --replace 'pkill' '${if stdenv.isLinux then procps else "/usr"}/bin/pkill'
  '';

  nativeBuildInputs = with python3Packages; [
    poetry-core
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

  meta = {
    homepage = "https://developers.yubico.com/yubikey-manager";
    changelog = "https://github.com/Yubico/yubikey-manager/releases/tag/${version}";
    description = "Command line tool for configuring any YubiKey over all USB transports";

    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ benley lassulus pinpox nickcao ];
    mainProgram = "ykman";
  };
}
