{ stdenv, fetchFromGitHub, v8, perl, postgresql }:

stdenv.mkDerivation rec {
  name = "plv8-${version}";
  version = "2.0.3";

  nativeBuildInputs = [ perl ];
  buildInputs = [ v8 postgresql ];

  src = fetchFromGitHub {
    owner = "plv8";
    repo = "plv8";
    rev = "v${version}";
    sha256 = "0cn7ynckmdb08dkzjilvc55xz61d1jiya7yrnphizw404j84y3qc";
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
