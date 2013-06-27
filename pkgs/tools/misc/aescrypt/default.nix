{ stdenv, fetchurl }:
 
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
 
  buildInputs = [];
 
  meta = {
    description = "AES Crypt is a file encryption software available on several operating systems that uses the industry standard Advanced Encryption Standard (AES) to easily and securely encrypt files.";
    homepage = http://www.aescrypt.com/;
    license = "GPLv2";
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.qknight ];
  };
}

