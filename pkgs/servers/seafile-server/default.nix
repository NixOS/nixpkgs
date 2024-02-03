{ stdenv, lib, fetchFromGitHub, pkg-config, python3, autoreconfHook
, libuuid, sqlite, glib, libevent, libsearpc, openssl, fuse, libarchive, which
, vala, cmake, oniguruma, nixosTests }:

let
  # seafile-server relies on a specific version of libevhtp.
  # It contains non upstreamed patches and is forked off an outdated version.
  libevhtp = import ./libevhtp.nix {
    inherit stdenv lib fetchFromGitHub cmake libevent;
  };
in stdenv.mkDerivation rec {
  pname = "seafile-server";
  version = "9.0.10";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seafile-server";
    rev = "079a8b65a543bfbc48e7671c3dbbffe19fd02944"; # using a fixed revision because upstream may re-tag releases :/
    sha256 = "sha256-F1n4E6ajpri3CVM7B28UKoTV1oOLr5nTy6Lw0E5tCrc=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [
    libuuid
    sqlite
    openssl
    glib
    libsearpc
    libevent
    python3
    fuse
    libarchive
    which
    vala
    libevhtp
    oniguruma
  ];

  postInstall = ''
    mkdir -p $out/share/seafile/sql
    cp -r scripts/sql $out/share/seafile
  '';

  passthru.tests = {
    inherit (nixosTests) seafile;
  };

  meta = with lib; {
    description = "File syncing and sharing software with file encryption and group sharing, emphasis on reliability and high performance";
    homepage = "https://github.com/haiwen/seafile-server";
    license = licenses.agpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ greizgh schmittlauch ];
  };
}
