{ lib, stdenv
, fetchFromGitHub
, fetchpatch
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
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "VirusTotal";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-axHFy7YwLhhww+lh+ORyW6YG+T385msysIHK5SMyhMk=";
  };

  # FIXME: make unconditional on staging
  patches = lib.optionals (!stdenv.hostPlatform.isGnu && !stdenv.hostPlatform.isDarwin) [
    (fetchpatch {
      name = "musl.patch";
      url = "https://github.com/VirusTotal/yara/commit/515ed861cf30e154b14a69ffd46c347fb81df72f.patch";
      hash = "sha256-2scnUyz0SSkNRlsVQapPgI1ATIPXEogqtxbimYYq4Jo=";
    })
  ];

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
