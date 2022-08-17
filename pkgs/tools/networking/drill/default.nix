{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "drill";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "fcsonline";
    repo = pname;
    rev = version;
    sha256 = "sha256-J4zg5mAZ/xXKxBbEYYZRNjlbyUD/SDD/LSu43FrCbBE=";
  };

  cargoSha256 = "sha256-N0Rj6n8mQHZR4/4m1FHcqCKDqG7GeVxUs2XN0oxQVqQ=";

  nativeBuildInputs = lib.optionals stdenv.isLinux [
    pkg-config
  ];

  OPENSSL_LIB_DIR = "${lib.getLib openssl}/lib";
  OPENSSL_DIR="${lib.getDev openssl}";

  buildInputs = lib.optionals stdenv.isLinux [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

  meta = with lib; {
    description = "HTTP load testing application inspired by Ansible syntax";
    homepage = "https://github.com/fcsonline/drill";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
