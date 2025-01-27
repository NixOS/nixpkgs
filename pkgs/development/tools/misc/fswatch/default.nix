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
  version = "1.18.2";

  src = fetchFromGitHub {
    owner = "emcrisostomo";
    repo = "fswatch";
    rev = version;
    sha256 = "sha256-u9+sayp0U6TudffGP2Bb2PbbSMjUHCb6gGBq3jKQ3EQ=";
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
