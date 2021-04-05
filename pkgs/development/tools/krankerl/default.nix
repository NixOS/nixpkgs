{ lib
, fetchgit
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
  version = "v0.13.0";

  src = fetchgit {
    url = "https://github.com/ChristophWurst/krankerl.git";
    rev = version;
    sha256 = "1gp8b2m8kcz2f16zv9xwv4n1zki6imvz9z31kixh6amdj6fif3d1";
  };

  cargoSha256 = "sha256:00b634w9kwbqjhyifnb3py2mdqghhf6j82q4k555fffidy1pnzxx";

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
    description = " A CLI helper to manage, package and publish Nextcloud apps ";
    homepage = "https://github.com/ChristophWurst/krankerl";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ onny ];
  };
}
