{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "mqttui";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "EdJoPaTo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XREY86CcxH+YqzOpu5vXiP6lIZaj+twKQgGmn7MR1As=";
  };

  cargoSha256 = "sha256-V5jVgNIV+Bl1nYKy2RYFbKYo/x65gG3RmB+XjFATxN8=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "Terminal client for MQTT";
    homepage = "https://github.com/EdJoPaTo/mqttui";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
