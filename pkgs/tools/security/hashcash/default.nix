{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  name = "hashcash-${version}";
  version = "1.22";

  buildInputs = [ openssl ];

  src = fetchurl {
      url = "http://www.hashcash.org/source/hashcash-1.22.tgz";
      sha256 = "15kqaimwb2y8wvzpn73021bvay9mz1gqqfc40gk4hj6f84nz34h1";
  };

  makeFlags = "generic-openssl LIBCRYPTO=-lcrypto";

  installPhase = ''
    install -D -m 0755 --target $out/bin hashcash sha1
    install -D -m 0444 hashcash.1 $out/share/man/man1/hashcash.1
  '';

  meta = with stdenv.lib; {
    description = "Proof-of-work algorithm used as spam and denial-of-service counter measure";
    homepage = http://hashcash.org;
    license = licenses.gpl2;
    maintainers = with maintainers; [ kisonecat ];
  };
}
