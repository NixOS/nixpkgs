{ stdenv, fetchgit, nodejs, which, python27 }:

let
  date = "20140829";
  rev = "9595d67f9edd759054c5bd3aaee0968ff55e361a";
in
stdenv.mkDerivation {
  name = "cjdns-${date}-${stdenv.lib.strings.substring 0 7 rev}";

  src = fetchgit {
    url = "https://github.com/cjdelisle/cjdns.git";
    inherit rev;
    sha256 = "519c549c42ae26c5359ae13a4548c44b51e36db403964b4d9f78c19b749dfb83";
  };

  buildInputs = [ which python27 nodejs];

  patches = [ ./makekey.patch ];

  buildPhase = "bash do";
  installPhase = ''
    mkdir -p $out/sbin
    cp cjdroute makekey $out/sbin
  '';

  meta = {
    homepage = https://github.com/cjdelisle/cjdns;
    description = "Encrypted networking for regular people";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ viric emery ];
    platforms = stdenv.lib.platforms.linux;
  };
}
