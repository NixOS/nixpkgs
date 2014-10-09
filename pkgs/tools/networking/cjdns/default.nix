{ stdenv, fetchgit, nodejs, which, python27 }:

let
  date = "20140922";
  rev = "5ebca772b0582173127e8c1e61ee235c5ab3fb50";
in
stdenv.mkDerivation {
  name = "cjdns-${date}-${stdenv.lib.strings.substring 0 7 rev}";

  src = fetchgit {
    url = "https://github.com/cjdelisle/cjdns.git";
    inherit rev;
    sha256 = "04abf73f4aede12c35b70ae09a367b3d6352a63f818185f788ed13356d06197a";
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
