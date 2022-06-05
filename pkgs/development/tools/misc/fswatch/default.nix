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
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "emcrisostomo";
    repo = "fswatch";
    rev = version;
    sha256 = "sha256-EKbo5gkrWuijLJgYsNBDtxy0ioXu/yHxnPPeOpk620g=";
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
