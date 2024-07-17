{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libevent,
  file,
  qrencode,
  miniupnpc,
}:

stdenv.mkDerivation rec {
  pname = "pshs";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "mgorny";
    repo = "pshs";
    rev = "v${version}";
    sha256 = "1j8j4r0vsmp6226q6jdgf9bzhx3qk7vdliwaw7f8kcsrkndkg6p4";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    libevent
    file
    qrencode
    miniupnpc
  ];

  # SSL requires libevent at 2.1 with ssl support
  configureFlags = [ "--disable-ssl" ];

  meta = {
    description = "Pretty small HTTP server - a command-line tool to share files";
    mainProgram = "pshs";
    homepage = "https://github.com/mgorny/pshs";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
}
