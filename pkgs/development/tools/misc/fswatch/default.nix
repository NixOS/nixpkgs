{ lib, stdenv
, fetchFromGitHub
, autoreconfHook
                     # for xargs
, gettext
, libtool
, makeWrapper
, texinfo
, CoreServices
}:

stdenv.mkDerivation rec {
  pname = "fswatch";
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "emcrisostomo";
    repo = "fswatch";
    rev = version;
    sha256 = "sha256-9xCp/SaqdUsVhOYr/QfAN/7RcRxsybCmfiO91vf3j40=";
  };

  nativeBuildInputs = [ autoreconfHook makeWrapper ] ++ lib.optionals stdenv.isDarwin [ CoreServices ];
  buildInputs = [ gettext libtool texinfo ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A cross-platform file change monitor with multiple backends";
    homepage = "https://github.com/emcrisostomo/fswatch";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ pSub ];
  };
}
