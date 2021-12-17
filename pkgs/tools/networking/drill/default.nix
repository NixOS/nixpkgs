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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "fcsonline";
    repo = pname;
    rev = version;
    sha256 = "07zz0dj0wjwrc1rmayz7s8kpcv03i0ygl4vfwsam72qd4nf6v538";
  };

  cargoSha256 = "04gj9gaysjcm2d81ds2raak847hr8w84jgfdwqd51wi8xm32w5jf";

  nativeBuildInputs = lib.optionals stdenv.isLinux [
    pkg-config
  ];

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
