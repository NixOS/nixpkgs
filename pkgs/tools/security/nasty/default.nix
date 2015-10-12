{ stdenv, fetchurl, gpgme }:

stdenv.mkDerivation rec {
  name = "nasty-${version}";
  version = "0.6";

  src = fetchurl {
    url = "http://www.vanheusden.com/nasty/${name}.tgz";
    sha256 = "1dznlxr728k1pgy1kwmlm7ivyl3j3rlvkmq34qpwbwbj8rnja1vn";
  };

  buildInputs = [ gpgme ];

  installPhase = ''
    mkdir -p $out/bin
    cp nasty $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Recover the passphrase of your PGP or GPG-key";
    longDescription = ''
    Nasty is a program that helps you to recover the passphrase of your PGP or GPG-key
    in case you forget or lost it. It is mostly a proof-of-concept: with a different implementation
    this program could be at least 100x faster.
    '';
    homepage = http://www.vanheusden.com/nasty/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ davidak ];
    platforms = with platforms; unix;
  };
}

