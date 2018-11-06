{ stdenv, fetchFromGitHub, autoconf, automake, libtool, pcre
, withCrypto ? true, openssl
, enableMagic ? true, file
, enableCuckoo ? true, jansson
}:

stdenv.mkDerivation rec {
  version = "3.8.1";
  name = "yara-${version}";

  src = fetchFromGitHub {
    owner = "VirusTotal";
    repo = "yara";
    rev = "v${version}";
    sha256 = "1ys2y5f2cif3g42daq646jcrn2na19zkx7fds2gnavj5c1rk7463";
  };

  buildInputs = [ autoconf automake libtool pcre]
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
