{ lib, stdenv, fetchFromGitHub, hiredis, http-parser, jansson, libevent, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "webdis";
  version = "0.1.20";

  src = fetchFromGitHub {
    owner = "nicolasff";
    repo = pname;
    rev = version;
    sha256 = "sha256-QvPawRYmk5HcE4XnI4B4G7AAaN/8cFov9lOa2e++g4A=";
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
