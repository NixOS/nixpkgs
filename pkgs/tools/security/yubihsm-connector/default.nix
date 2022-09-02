{ lib, libusb1, buildGoModule, fetchFromGitHub, pkg-config }:

buildGoModule rec {
  pname = "yubihsm-connector";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "Yubico";
    repo = "yubihsm-connector";
    rev = version;
    sha256 = "FQ64tSZN55QpXjMZITzlWOPTKSgnoCpkRngQUQHVavc=";
  };

  vendorSha256 = "kVBzdJk/1LvjdUtLqHAw9ZxDfCo3mBWVMYG/nQXpDrk=";

  patches = [
    # Awaiting a new release to fix the upstream lockfile
    # https://github.com/Yubico/yubihsm-connector/issues/36
    ./lockfile-fix.patch
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libusb1
  ];

  preBuild = ''
    go generate
  '';

  meta = with lib; {
    description = "yubihsm-connector performs the communication between the YubiHSM 2 and applications that use it";
    homepage = "https://developers.yubico.com/yubihsm-connector/";
    maintainers = with maintainers; [ matthewcroughan ];
    license = licenses.asl20;
  };
}
