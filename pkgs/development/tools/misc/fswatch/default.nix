{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  # for xargs
  gettext,
  libtool,
  makeWrapper,
  texinfo,
  CoreServices,
}:

stdenv.mkDerivation rec {
  pname = "fswatch";
  version = "1.18.0";

  src = fetchFromGitHub {
    owner = "emcrisostomo";
    repo = "fswatch";
    rev = version;
    sha256 = "sha256-n9EDEF5swC7UyvC0cd+U/u4Wd050Jf9h2AVtEVbUICA=";
  };

  nativeBuildInputs = [
    autoreconfHook
    makeWrapper
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ CoreServices ];
  buildInputs = [
    gettext
    libtool
    texinfo
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Cross-platform file change monitor with multiple backends";
    mainProgram = "fswatch";
    homepage = "https://github.com/emcrisostomo/fswatch";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ pSub ];
  };
}
