{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitHub,
  gettext,
  libmaxminddb,
  ncurses,
  openssl,
  withGeolocation ? true,
}:

stdenv.mkDerivation rec {
  pname = "goaccess";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "allinurl";
    repo = "goaccess";
    rev = "refs/tags/v${version}";
    hash = "sha256-ZOngDAHA88YQvkx2pk5ZSpBzxqelvCIR4z5hiFmfGyc=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs =
    [
      ncurses
      openssl
    ]
    ++ lib.optionals withGeolocation [ libmaxminddb ]
    ++ lib.optionals stdenv.isDarwin [ gettext ];

  configureFlags = [
    "--enable-utf8"
    "--with-openssl"
  ] ++ lib.optionals withGeolocation [ "--enable-geoip=mmdb" ];

  meta = with lib; {
    description = "Real-time web log analyzer and interactive viewer that runs in a terminal in *nix systems";
    homepage = "https://goaccess.io";
    changelog = "https://github.com/allinurl/goaccess/raw/v${version}/ChangeLog";
    license = licenses.mit;
    maintainers = with maintainers; [ ederoyd46 ];
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "goaccess";
  };
}
