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
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "VirusTotal";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-xjGlK0jUDpkDXnI0odErtF+Xcx0I/orD0v5EZw8mhvs=";
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
