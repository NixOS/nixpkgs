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
  version = "8.0.8";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seafile-server";
    rev = "807867afb7a86f526a6584278914ce9f3f51d1da";
    sha256 = "1nq6dw4xzifbyhxn7yn5398q2sip1p1xwqz6xbis4nzgx4jldd4g";
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
