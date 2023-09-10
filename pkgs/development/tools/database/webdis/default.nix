{ lib, stdenv, fetchFromGitHub, hiredis, http-parser, jansson, libevent, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "webdis";
  version = "0.1.21";

  src = fetchFromGitHub {
    owner = "nicolasff";
    repo = pname;
    rev = version;
    sha256 = "sha256-HSAxmOtljwhQiW/spe0MEF7JK+bZe+oSUJhwp5y1fEQ=";
  };

  buildInputs = [ hiredis http-parser jansson libevent ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "CONFDIR=${placeholder "out"}/share/webdis"
  ];

  meta = with lib; {
    description = "A Redis HTTP interface with JSON output";
    homepage = "https://webd.is/";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wucke13 ];
  };
}
