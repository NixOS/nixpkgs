{ lib
, stdenvNoCC
, fetchzip
, autoPatchelfHook
, libcxx
}:

stdenvNoCC.mkDerivation rec {
  pname = "aapt";
  version = "8.4.1-11315950";

  src =
    let
      urlAndHash =
        if stdenvNoCC.isLinux then {
          url = "https://dl.google.com/android/maven2/com/android/tools/build/aapt2/${version}/aapt2-${version}-linux.jar";
          hash = "sha256-eSQaZrRtb5aCG320hrXAL256fxa/oMhBC4hcTA1KRxs=";
        } else if stdenvNoCC.isDarwin then {
          url = "https://dl.google.com/android/maven2/com/android/tools/build/aapt2/${version}/aapt2-${version}-osx.jar";
          hash = "sha256-LUihNjase79JbUkHDb10A5d6pJ+VXDVfv7m09hkL8kY=";
        } else throw "Unsupport platform: ${stdenvNoCC.system}";
    in
    fetchzip (urlAndHash // {
      extension = "zip";
      stripRoot = false;
    });

  nativeBuildInputs = lib.optionals stdenvNoCC.isLinux [ autoPatchelfHook ];
  buildInputs = lib.optionals stdenvNoCC.isLinux [ libcxx ];

  installPhase = ''
    runHook preInstall

    install -D aapt2 $out/bin/aapt2

    runHook postInstall
  '';

  meta = {
    description = "Build tool that compiles and packages Android app's resources";
    mainProgram = "aapt2";
    homepage = "https://developer.android.com/tools/aapt2";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ linsui ];
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}

