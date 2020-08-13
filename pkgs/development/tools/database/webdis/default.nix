{ stdenv, fetchFromGitHub, hiredis, http-parser, jansson, libevent, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "webdis";
  version = "0.1.11";

  src = fetchFromGitHub {
    owner = "nicolasff";
    repo = pname;
    rev = version;
    sha256 = "162xbx4dhfx4a6sksm7x60gr7ylyila4vidmdf0bn7xlvglggazf";
  };

  buildInputs = [ hiredis http-parser jansson libevent ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "CONFDIR=${placeholder "out"}/share/webdis"
  ];

  meta = with stdenv.lib; {
    description = "A Redis HTTP interface with JSON output";
    homepage = "https://webd.is/";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wucke13 ];
  };
}
