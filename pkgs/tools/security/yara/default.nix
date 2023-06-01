{ lib, stdenv
, fetchFromGitHub
, autoreconfHook
, pcre
, pkg-config
, protobufc
, withCrypto ? true, openssl
, enableCuckoo ? true, jansson
, enableDex ? true
, enableDotNet ? true
, enableMacho ? true
, enableMagic ? true, file
, enableStatic ? false
}:

stdenv.mkDerivation rec {
  pname = "yara";
  version = "4.3.1";

  src = fetchFromGitHub {
    owner = "VirusTotal";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Q+Q52W/MhurG3x0CIr0nv31qc4bdaLDk9AGGpMxKOcI=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    pcre
    protobufc
  ] ++ lib.optionals withCrypto [
    openssl
  ] ++ lib.optionals enableMagic [
    file
  ] ++ lib.optionals enableCuckoo [
    jansson
  ];

  preConfigure = "./bootstrap.sh";

  configureFlags = [
    (lib.withFeature withCrypto "crypto")
    (lib.enableFeature enableCuckoo "cuckoo")
    (lib.enableFeature enableDex "dex")
    (lib.enableFeature enableDotNet "dotnet")
    (lib.enableFeature enableMacho "macho")
    (lib.enableFeature enableMagic "magic")
    (lib.enableFeature enableStatic "static")
  ];

  doCheck = enableStatic;

  meta = with lib; {
    description = "The pattern matching swiss knife for malware researchers";
    homepage = "http://Virustotal.github.io/yara/";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    platforms = platforms.all;
  };
}
