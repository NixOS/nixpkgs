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
, krankerl
, testVersion
}:

rustPlatform.buildRustPackage rec {
  pname = "krankerl";
  version = "0.13.3";

  src = fetchFromGitHub {
    owner = "ChristophWurst";
    repo = "krankerl";
    rev = "v${version}";
    sha256 = "sha256-/zRO+CVYQgx9/j14zgNm/ABzLprt0OYne+O6hOEjSEw=";
  };

  cargoSha256 = "sha256-LWQRFgDxl2yxP+v1TUENaTGrA/udh84AJvWIkfTJezM=";

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

  passthru.tests.version = testVersion { package = krankerl; };

  meta = with lib; {
    description = "A CLI helper to manage, package and publish Nextcloud apps";
    homepage = "https://github.com/ChristophWurst/krankerl";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ onny ];
  };
}
