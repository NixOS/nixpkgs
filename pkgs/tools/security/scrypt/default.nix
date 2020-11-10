{ stdenv, fetchurl, openssl, utillinux, getconf }:

stdenv.mkDerivation rec {
  pname = "scrypt";
  version = "1.3.1";

  src = fetchurl {
    url = "https://www.tarsnap.com/scrypt/${pname}-${version}.tgz";
    sha256 = "1hnl0r6pmyxiy4dmafmqk1db7wpc0x9rqpzqcwr9d2cmghcj6byz";
  };

  outputs = [ "out" "lib" "dev" ];

  configureFlags = [ "--enable-libscrypt-kdf" ];

  buildInputs = [ openssl ];

  nativeBuildInputs = [ getconf ];

  patchPhase = ''
    for f in Makefile.in autotools/Makefile.am libcperciva/cpusupport/Build/cpusupport.sh configure ; do
      substituteInPlace $f --replace "command -p " ""
    done

    patchShebangs tests/test_scrypt.sh
  '';

  doCheck = true;
  checkTarget = "test";
  checkInputs = [ utillinux ];

  meta = with stdenv.lib; {
    description = "Encryption utility";
    homepage    = "https://www.tarsnap.com/scrypt.html";
    license     = licenses.bsd2;
    platforms   = platforms.all;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
