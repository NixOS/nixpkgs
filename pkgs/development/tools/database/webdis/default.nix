{ lib, stdenv, fetchFromGitHub, hiredis, http-parser, jansson, libevent, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "webdis";
  version = "0.1.16";

  src = fetchFromGitHub {
    owner = "nicolasff";
    repo = pname;
    rev = version;
    sha256 = "sha256-I+Nq3kjXoQlwfj8r7oNu6KFE6hnB076M9aJMdwCas3k=";
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
