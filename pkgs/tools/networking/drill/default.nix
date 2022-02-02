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
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "fcsonline";
    repo = pname;
    rev = version;
    sha256 = "sha256-LqqtSmmXr48jB7HyWi954fDNKOynEpQupGYl7QbXUAI=";
  };

  cargoSha256 = "sha256-SUF/gDy9t2B5N234HZHxMl0Hc0GrVUBw3xeI43c++Nc=";

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
