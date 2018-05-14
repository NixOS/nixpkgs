{ stdenv, fetchurl, libiconv }:

stdenv.mkDerivation rec {
  version = "3.13";
  name = "aescrypt-${version}";

  src = fetchurl {
    url = "https://www.aescrypt.com/download/v3/linux/${name}.tgz";
    sha256 = "1a1rs7xmbxh355qg3v02rln3gshvy3j6wkx4g9ir72l22mp6zkc7";
  };

  preBuild = ''
    cd src
  '';

  installPhase= ''
    mkdir -p $out/bin
    cp aescrypt $out/bin
    cp aescrypt_keygen $out/bin
  '';

  buildInputs = [ libiconv ];

  meta = with stdenv.lib; {
    description = "Encrypt files with Advanced Encryption Standard (AES)";
    homepage    = https://www.aescrypt.com/;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ lovek323 qknight ];
    platforms   = stdenv.lib.platforms.all;
    hydraPlatforms = stdenv.lib.platforms.linux;
  };
}
