{ stdenv, fetchurl, libiconv }:

stdenv.mkDerivation rec {
  version = "3.14";
  pname = "aescrypt";

  src = fetchurl {
    url = "https://www.aescrypt.com/download/v3/linux/${pname}-${version}.tgz";
    sha256 = "1iziymcbpc64d44djgqfifpblsly4sr5bxsp5g29jgxz552kjlah";
  };

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isDarwin "-liconv";

  preBuild = ''
    substituteInPlace src/Makefile --replace "CC=gcc" "CC?=gcc"
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
    homepage    = "https://www.aescrypt.com/";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ lovek323 qknight ];
    platforms   = stdenv.lib.platforms.all;
    hydraPlatforms = with platforms; unix;
  };
}
