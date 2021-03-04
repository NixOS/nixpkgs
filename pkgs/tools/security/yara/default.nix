{ lib, stdenv
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
  version = "4.0.5";
  pname = "yara";

  src = fetchFromGitHub {
    owner = "VirusTotal";
    repo = "yara";
    rev = "v${version}";
    sha256 = "1gkdll2ygdlqy1f27a5b84gw2bq75ss7acsx06yhiss90qwdaalq";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ pcre protobufc ]
    ++ lib.optionals withCrypto [ openssl ]
    ++ lib.optionals enableMagic [ file ]
    ++ lib.optionals enableCuckoo [ jansson ]
  ;

  preConfigure = "./bootstrap.sh";

  configureFlags = [
    (lib.withFeature withCrypto "crypto")
    (lib.enableFeature enableMagic "magic")
    (lib.enableFeature enableCuckoo "cuckoo")
    (lib.enableFeature true "static")
  ];

  meta = with lib; {
    description = "The pattern matching swiss knife for malware researchers";
    homepage = "http://Virustotal.github.io/yara/";
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
