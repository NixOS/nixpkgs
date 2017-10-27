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

  preConfigure = ''
    substituteInPlace Makefile --replace '-lv8_libplatform' '-lv8_libplatform -lv8_libbase'
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -D plv8.so                                         -t $out/lib
    install -D {plls,plcoffee,plv8}{--${version}.sql,.control} -t $out/share/extension
  '';

  meta = with stdenv.lib; {
    description = "PL/v8 - A Procedural Language in JavaScript powered by V8";
    homepage = https://pgxn.org/dist/plv8/;
    maintainers = with maintainers; [ volth ];
    platforms = platforms.linux;
    license = licenses.postgresql;
  };
}
