{ stdenv, lib, fetchFromGitHub, pkg-config, python3Packages, autoreconfHook
, libuuid, sqlite, glib, libevent, libsearpc, openssl, fuse, libarchive, which
, vala, cmake, oniguruma }:

let
  # seafile-server relies on a specific version of libevhtp.
  # It contains non upstreamed patches and is forked off an outdated version.
  libevhtp = import ./libevhtp.nix {
    inherit stdenv lib fetchFromGitHub cmake libevent;
  };
in stdenv.mkDerivation rec {
  pname = "seafile-server";
  version = "8.0.7";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seafile-server";
    rev = "27dac89bb3a81c5acc3f764ce92134eb357ea64b";
    sha256 = "1h2hxvv0l5m9nbkdyjpznb7ddk8hb8hhwj8b2lx6aqbvp8gll9q7";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [
    libuuid
    sqlite
    openssl
    glib
    libsearpc
    libevent
    python3Packages.python
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

  meta = with lib; {
    description = "File syncing and sharing software with file encryption and group sharing, emphasis on reliability and high performance";
    homepage = "https://github.com/haiwen/seafile-server";
    license = licenses.agpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ greizgh schmittlauch ];
  };
}
