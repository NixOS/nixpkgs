{ stdenv
, fetchFromGitHub
, autoreconfHook
, pcre
, pkg-config
, protobufc
, withCrypto ? true, openssl
, enableMagic ? true, file
, enableCuckoo ? true, jansson
}:

stdenv.mkDerivation rec {
  version = "4.0.1";
  pname = "yara";

  src = fetchFromGitHub {
    owner = "VirusTotal";
    repo = "yara";
    rev = "v${version}";
    sha256 = "0dy8jf0pdn0wilxy1pj6pqjxg7icxkwax09w54np87gl9p00f5rk";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ pcre protobufc ]
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
    homepage = "http://Virustotal.github.io/yara/";
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
