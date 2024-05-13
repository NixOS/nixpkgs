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
  version = "4.5.0";

  src = fetchFromGitHub {
    owner = "VirusTotal";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-AecHsUBtBleUkWuYMQ4Tx/PY8cs9j7JwqncBziJD0hA=";
  };

  patches = [
    (fetchpatch {
      name = "LFS64.patch";
      url = "https://github.com/VirusTotal/yara/commit/833a580430abe0fbc9bc17a21fb95bf36dacf367.patch";
      hash = "sha256-EmwyDsxaNd9zfpAOu6ZB9kzg04qB7LAD7UJB3eAuKd8=";
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
