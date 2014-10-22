{ stdenv, fetchFromGitHub, nodejs, which, python27 }:

let
  date = "20140928";
  rev = "e2b673698e471dbc82b4e9dbc04cb9e16f1f06a6";
in
stdenv.mkDerivation {
  name = "cjdns-${date}-${stdenv.lib.strings.substring 0 7 rev}";

  src = fetchFromGitHub {
    owner = "cjdelisle";
    repo = "cjdns";
    inherit rev;
    sha256 = "0ql51845rni6678dda03zr18ary7xlqcs3khva9x80x815h1sy8v";
  };

  patches = [ ./rfc5952.patch ];

  buildInputs = [ which python27 nodejs];

  buildPhase = "bash do";
  installPhase = "installBin cjdroute makekeys privatetopublic publictoip6";

  meta = with stdenv.lib; {
    homepage = https://github.com/cjdelisle/cjdns;
    description = "Encrypted networking for regular people";
    license = licenses.gpl3;
    maintainers = with maintainers; [ viric emery ];
    platforms = platforms.unix;
  };
}
