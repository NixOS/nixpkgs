{ lib
, stdenv
, fetchurl
, libopensmtpd
, openssl
, mandoc
}:
stdenv.mkDerivation rec {
  pname = "opensmtpd-filter-dkimsign";
  version = "0.6";

  src = fetchurl {
    url = "https://imperialat.at/releases/filter-dkimsign-${version}.tar.gz";
    hash = "sha256-O18NtAuSNg82uKnUx+R4h3e1IBSElTrFWBBkr2AYNsM=";
  };

  patches = [ ./no-chown-while-installing.patch ];

  buildInputs = [ libopensmtpd openssl ];

  nativeBuildInputs = [ mandoc ];

  makeFlags = [
    "-f Makefile.gnu"
    "HAVE_ED25519=1"
    "DESTDIR=$(out)"
    "LOCALBASE="
  ];

  meta = with lib; {
    description = "OpenSMTPD filter for DKIM signing";
    homepage = "http://imperialat.at/dev/filter-dkimsign/";
    license = licenses.isc;
    maintainers = with maintainers; [ malte-v ];
  };
}
