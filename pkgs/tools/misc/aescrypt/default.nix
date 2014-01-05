{ stdenv, fetchurl, libiconvOrEmpty }:

stdenv.mkDerivation rec {
  version = "3.0.9";
  name = "aescrypt-${version}";

  src = fetchurl {
    url = "http://www.aescrypt.com/download/v3/linux/${name}.tgz";
    sha256 = "3f3590f9b7e50039611ba9c0cf1cae1b188a44bd39cfc41553db7ec5709c0882";
  };

  preBuild = ''
    cd src
  '';

  installPhase= ''
    mkdir -p $out/bin
    cp aescrypt $out/bin
    cp aescrypt_keygen $out/bin
  '';

  buildInputs = [ libiconvOrEmpty ];

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isDarwin "-liconv";

  meta = with stdenv.lib; {
    description = "encrypt files with Advanced Encryption Standard (AES)";
    homepage    = http://www.aescrypt.com/;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ lovek323 qknight ];
    platforms   = stdenv.lib.platforms.all;
    hydraPlatforms = stdenv.lib.platforms.linux;
  };
}
