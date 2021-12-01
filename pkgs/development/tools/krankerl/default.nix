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
  version = "0.13.2";

  src = fetchFromGitHub {
    owner = "ChristophWurst";
    repo = "krankerl";
    rev = "v${version}";
    sha256 = "sha256-Kol39AtM5m6FC+s5SDbQhWuASkGbeXPlmSGb7axEuK8=";
  };

  cargoSha256 = "sha256-bPcKe3vE3VIjLJ4iYdF3Gt0sID09gRpxG5TpTGWhnPs=";

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
