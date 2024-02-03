{ lib
, stdenv
, fetchFromGitHub
, hiredis
, http-parser
, jansson
, libevent
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "webdis";
  version = "0.1.22";

  src = fetchFromGitHub {
    owner = "nicolasff";
    repo = "webdis";
    rev = finalAttrs.version;
    hash = "sha256-83nZMqRK1uEWR1xn9lzbTyM0kuAkhmvm999cGu6Yu3k=";
  };

  buildInputs = [ hiredis http-parser jansson libevent ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "CONFDIR=${placeholder "out"}/share/webdis"
  ];

  meta = {
    description = "A Redis HTTP interface with JSON output";
    homepage = "https://webd.is/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ wucke13 ];
    platforms = lib.platforms.unix;
  };
})
