{ stdenv, fetchFromGitHub, v8, perl, postgresql }:

stdenv.mkDerivation rec {
  name = "plv8-${version}";
  version = "2.1.0";

  nativeBuildInputs = [ perl ];
  buildInputs = [ v8 postgresql ];

  src = fetchFromGitHub {
    owner = "plv8";
    repo = "plv8";
    rev = "v${version}";
    sha256 = "1sfpxz0zcbinn6822j12lkwgrw9kfacrs83ic968rm489rl9w241";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  preConfigure = ''
    substituteInPlace Makefile \
      --replace '-lv8_libplatform' '-lv8_libplatform -lv8_libbase'
  '';

  passthru = {
    versionCheck = postgresql.compareVersion "11" < 0;
  };

  meta = with stdenv.lib; {
    description = "PL/v8 - A Procedural Language in JavaScript powered by V8";
    homepage = https://pgxn.org/dist/plv8/;
    maintainers = with maintainers; [ volth ];
    platforms = platforms.linux;
    license = licenses.postgresql;
  };
}
