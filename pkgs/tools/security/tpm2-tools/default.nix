{ stdenv, fetchurl, fetchpatch, lib
, cmocka, curl, pandoc, pkgconfig, openssl, tpm2-tss }:

stdenv.mkDerivation rec {
  pname = "tpm2-tools";
  version = "3.1.4";

  src = fetchurl {
    url = "https://github.com/tpm2-software/${pname}/releases/download/${version}/${pname}-${version}.tar.gz";
    sha256 = "0cv09wnf7sw17z1n898w0zmk58y8b1why58m63hqx5d7x4054l9g";
  };

  nativeBuildInputs = [ pandoc pkgconfig ];
  buildInputs = [
    curl openssl tpm2-tss
    # For unit tests.
    cmocka
  ];

  configureFlags = [ "--enable-unit" ];
  doCheck = true;

  meta = with lib; {
    description = "Command line tools that provide access to a TPM 2.0 compatible device";
    homepage = https://github.com/tpm2-software/tpm2-tools;
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ delroth ];
  };
}
