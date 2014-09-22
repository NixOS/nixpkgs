{ stdenv, fetchgit, nodejs, which, python27 }:

let
  date = "20140919";
  rev = "e9bcb0f9f06870d6f4904149e1c15eca09c7ed8a";
in
stdenv.mkDerivation {
  name = "cjdns-${date}-${stdenv.lib.strings.substring 0 7 rev}";

  src = fetchgit {
    url = "https://github.com/cjdelisle/cjdns.git";
    inherit rev;
    sha256 = "e9fa82f3495b718cebd4d1836312b224c6689dc521fba093ad1accf2d2e15ff1";
  };

  buildInputs = [ which python27 nodejs];

  patches = [ ./makekey.patch ];

  buildPhase = "bash do";
  installPhase = "installBin cjdroute makekey";

  meta = {
    homepage = https://github.com/cjdelisle/cjdns;
    description = "Encrypted networking for regular people";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ viric emery ];
    platforms = stdenv.lib.platforms.linux;
  };
}
