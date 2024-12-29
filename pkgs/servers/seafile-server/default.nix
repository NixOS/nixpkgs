{ stdenv
, lib
, fetchFromGitHub
, pkg-config
, python3
, autoreconfHook
, libuuid
, sqlite
, glib
, libevent
, libsearpc
, openssl
, fuse
, libarchive
, libjwt
, curl
, which
, vala
, cmake
, oniguruma
, nixosTests
}:

let
  # seafile-server relies on a specific version of libevhtp.
  # It contains non upstreamed patches and is forked off an outdated version.
  libevhtp = import ./libevhtp.nix {
    inherit stdenv lib fetchFromGitHub cmake libevent;
  };
in
stdenv.mkDerivation rec {
  pname = "seafile-server";
  version = "10.0.1";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seafile-server";
    rev = "db09baec1b88fc131bf4453a808ab63a3fc714c9"; # using a fixed revision because upstream may re-tag releases :/
    sha256 = "sha256-a5vtJcbnaYzq6/3xmhbWk23BZ+Wil/Tb/q22ML4bDqs=";
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
    libjwt
    curl
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
