{ lib
, fetchzip
, stdenvNoCC
, makeWrapper

, testers
, secretive
}:

stdenvNoCC.mkDerivation rec {
  pname = "secretive";
  version = "2.3.0";

  src = fetchzip {
    url = "https://github.com/maxgoedjen/secretive/releases/download/v${version}/Secretive.zip";
    sha256 = "sha256-ohJNo2XAvT0yfMs06QidDhTa5M6r8BkYYN4HVDU5KYU=";
    stripRoot = false;
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{Applications,bin}
    cp -r ./Secretive.app $out/Applications

    makeWrapper $out/Applications/Secretive.app/Contents/MacOS/Secretive $out/bin/Secretive

    runHook postInstall
  '';

  passthru = {
    tests.codesign = testers.testDarwinCodesign {
      package = secretive;
      path = "Applications/Secretive.app";
      requireNotarization = true;
      teamId = "Z72PRUAWF6";
    };
  };

  meta = with lib; {
    description = "Store and manage SSH keys in the Secure Enclave";
    homepage = "https://github.com/maxgoedjen/secretive";
    changelog = "https://github.com/maxgoedjen/secretive/releases/tag/v${version}";
    mainProgram = "Secretive";
    license = licenses.mit;
    platforms = platforms.darwin;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ zhaofengli ];
  };
}
