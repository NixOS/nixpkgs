{ stdenv, fetchFromGitHub, hiredis, http-parser, jansson, libevent, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "webdis";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "nicolasff";
    repo = pname;
    rev = version;
    sha256 = "1kglzbs1sw3w05i678qr3lv4pxia20k2a8s3pjhfcxdlnlcy23sk";
  };

  patches = [
    # Do not use DESTDIR. See: https://github.com/nicolasff/webdis/pull/172
    (fetchpatch {
      url = "https://github.com/nicolasff/webdis/commit/a44a2964a59f2e583f4945eeb65cd19235059270.patch";
      sha256 = "0i41p98gc201vpp5ppjc9gxdyb1bpimr0qrvibaf3iq3sy4jr1gb";
    })
  ];

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
