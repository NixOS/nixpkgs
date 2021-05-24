{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, openssl
, dbus
, sqlite
, file
, gzip
, makeWrapper
}:

rustPlatform.buildRustPackage rec {
  pname = "krankerl";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "ChristophWurst";
    repo = "krankerl";
    rev = "v${version}";
    sha256 = "sha256-uIFcWHdW8887CDkFxZznh9akYs+vxsE9Bc9g1hKi7Kc=";
  };

  cargoSha256 = "sha256-6joHwz0HIVbta8ALvsJLMvmeDh9IFPR4Cx36H63MliI=";

  nativeBuildInputs = [
    pkg-config
    gzip
    makeWrapper
  ];

  buildInputs = [
    openssl
    dbus
    sqlite
  ];

  checkInputs = [
    file
  ];

  meta = with lib; {
    description = "A CLI helper to manage, package and publish Nextcloud apps";
    homepage = "https://github.com/ChristophWurst/krankerl";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ onny ];
  };
}
