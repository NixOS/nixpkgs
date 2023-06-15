{ lib
, stdenv
, autoreconfHook
, fetchFromGitHub
, file
, jansson
, openssl
, pcre
, pkg-config
, protobufc
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yara";
  version = "4.3.2";

  src = fetchFromGitHub {
    owner = "VirusTotal";
    repo = "yara";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-TmMHn/Zi/ZyJGHobEg9r1uLWu7e+8XJPwCvnUhQlD6I=";
  };

  withCrypto = true;
  enableCuckoo = true;
  enableDex = true;
  enableDotNet = true;
  enableMacho = true;
  enableMagic = true;
  enableStatic = false;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    pcre
    protobufc
  ] ++ lib.optionals finalAttrs.withCrypto [
    openssl
  ] ++ lib.optionals finalAttrs.enableMagic [
    file
  ] ++ lib.optionals finalAttrs.enableCuckoo [
    jansson
  ];

  preConfigure = ''
    ./bootstrap.sh
  '';

  configureFlags = lib.optionals finalAttrs.withCrypto [ "--without-crypto" ]
    ++ lib.optionals finalAttrs.enableCuckoo [ "--enable-cuckoo" ]
    ++ lib.optionals finalAttrs.enableDex [ "--enable-dex" ]
    ++ lib.optionals finalAttrs.enableDotNet [ "--enable-dotnet" ]
    ++ lib.optionals finalAttrs.enableMacho [ "--enable-macho" ]
    ++ lib.optionals finalAttrs.enableMagic [ "--enable-magic" ]
    ++ lib.optionals finalAttrs.enableStatic [ "--enable-static" ];

  doCheck = finalAttrs.enableStatic;

  meta = with lib; {
    description = "The pattern matching swiss knife for malware researchers";
    homepage = "http://Virustotal.github.io/yara/";
    changelog = "https://github.com/VirusTotal/yara/releases/tag/v${finalAttrs.version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    platforms = platforms.all;
  };
})
