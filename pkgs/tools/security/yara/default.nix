{ stdenv, fetchFromGitHub, fetchpatch, autoconf, automake, libtool, pcre
, withCrypto ? true, openssl
, enableMagic ? true, file
, enableCuckoo ? true, jansson
}:

stdenv.mkDerivation rec {
  version = "3.11.0";
  pname = "yara";

  src = fetchFromGitHub {
    owner = "VirusTotal";
    repo = "yara";
    rev = "v${version}";
    sha256 = "0mx3xm2a70fx8vlynkavq8gfd9w5yjcix5rx85444i2s1h6kcd0j";
  };

  # See: https://github.com/VirusTotal/yara/issues/1036
  # TODO: This patch should not be necessary in the next release
  patches = [
    (fetchpatch {
      url = "https://github.com/VirusTotal/yara/commit/04df811fa61fa54390b274bfcf56d7403c184404.patch";
      sha256 = "0hsbc2k7nmk2kskll971draz0an4rmcs5v0iql47mz596vqvkzmb";
    })
  ];

  buildInputs = [ autoconf automake libtool pcre ]
    ++ stdenv.lib.optionals withCrypto [ openssl ]
    ++ stdenv.lib.optionals enableMagic [ file ]
    ++ stdenv.lib.optionals enableCuckoo [ jansson ]
  ;

  preConfigure = "./bootstrap.sh";

  configureFlags = [
    (stdenv.lib.withFeature withCrypto "crypto")
    (stdenv.lib.enableFeature enableMagic "magic")
    (stdenv.lib.enableFeature enableCuckoo "cuckoo")
  ];

  meta = with stdenv.lib; {
    description = "The pattern matching swiss knife for malware researchers";
    homepage    = http://Virustotal.github.io/yara/;
    license     = licenses.asl20;
    platforms   = stdenv.lib.platforms.all;
  };
}
