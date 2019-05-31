{ stdenv, fetchFromGitHub, v8, perl, postgresql }:

stdenv.mkDerivation rec {
  pname = "plv8";
  version = "2.3.11";

  nativeBuildInputs = [ perl ];
  buildInputs = [ v8 postgresql ];

  src = fetchFromGitHub {
    owner = "plv8";
    repo = "plv8";
    rev = "v${version}";
    sha256 = "0bv2b8xxdqqhj6nwyc8kwhi5m5i7i1yl078sk3bnnc84b0mnza5x";
  };

  makeFlags = [ "--makefile=Makefile.shared" ];

  preConfigure = ''
    patchShebangs ./generate_upgrade.sh
  '';

  buildPhase = "make -f Makefile.shared all";

  installPhase = ''
    mkdir -p $out/bin
    install -D plv8*.so                                        -t $out/lib
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
