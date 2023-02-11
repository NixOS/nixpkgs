{ lib, stdenv, fetchurl, libpcap, perl }:

stdenv.mkDerivation rec {
  pname = "tcpdump";
  version = "4.99.1";

  src = fetchurl {
    url = "http://www.tcpdump.org/release/${pname}-${version}.tar.gz";
    sha256 = "sha256-ebNphfsnAxRmGNh8Ss3j4Gi5HFU/uT8CGjN/F1/RDr4=";
  };

  postPatch = ''
    patchShebangs tests
  '';

  nativeCheckInputs = [ perl ];

  buildInputs = [ libpcap ];

  configureFlags = lib.optional
    (stdenv.hostPlatform != stdenv.buildPlatform)
    "ac_cv_linux_vers=2";

  meta = with lib; {
    description = "Network sniffer";
    homepage = "https://www.tcpdump.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ globin ];
    platforms = platforms.unix;
  };
}
