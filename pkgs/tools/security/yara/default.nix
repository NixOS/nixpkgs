{ lib, stdenv
, fetchpatch
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

  # If static builds are disabled, `make all-am` will fail to find libyara.a and
  # cause a build failure. It appears that somewhere between yara 4.0.1 and
  # 4.0.5, linking the yara binaries dynamically against libyara.so was broken.
  #
  # This was already fixed in yara master. Backport the patch to yara 4.0.5.
  patches = [
    (fetchpatch {
      name = "fix-build-with-no-static.patch";
      url = "https://github.com/VirusTotal/yara/commit/52e6866023b9aca26571c78fb8759bc3a51ba6dc.diff";
      sha256 = "074cf99j0rqiyacp60j1hkvjqxia7qwd11xjqgcr8jmfwihb38nr";
    })
  ];

  configureFlags = [
    (lib.withFeature withCrypto "crypto")
    (lib.enableFeature enableCuckoo "cuckoo")
    (lib.enableFeature enableDex "dex")
    (lib.enableFeature enableDotNet "dotnet")
    (lib.enableFeature enableMacho "macho")
    (lib.enableFeature enableMagic "magic")
  ];

  meta = with lib; {
    description = "The pattern matching swiss knife for malware researchers";
    homepage = "http://Virustotal.github.io/yara/";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    platforms = platforms.all;
  };
}
