{ lib
, stdenv
, fetchurl
, installShellFiles
}:
let
  arch = with stdenv.hostPlatform; if isx86_64 then "amd64"
         else if isAarch64 then "arm64"
         else if isi686 then "386"
         else if isPower64 && isLittleEndian then "ppc64le"
         else if isS390x then "s390x"
         else throw "Unsupported arch: ${stdenv.hostPlatform.system}";
  platform = if stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64 then "macos_arm64"
             else if stdenv.hostPlatform.isDarwin then "macos"
             else "linux_${arch}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ibmcloud-cli";
  version = "2.30.0";

  src = fetchurl {
    url = "https://download.clis.cloud.ibm.com/ibm-cloud-cli/${finalAttrs.version}/binaries/IBM_Cloud_CLI_${finalAttrs.version}_${platform}.tgz";
    sha256 = {
      "x86_64-darwin"     = "5d4d16f35c034aa336e28b5685684146ec5773a6d7f456ed0d0e5d686adf4b25";
      "aarch64-darwin"    = "d563b8a4214da4360756bd18283b68c118139b5d3dd1b1d31c7ab7e61349e126";
      "x86_64-linux"      = "e6c874702851f16a3c21570020da85122a0ec0ca7e9dd75091684df1030d7295";
      "aarch64-linux"     = "6904c9de54845adcd08eb9906567493b68ad3f4cbba9d1121f63d9df2dd47185";
      "i686-linux"        = "bc6be9a65a6942e158ab202a2d1c89c4294b5cebf60841f4ac1d21064052e7e7";
      "powerpc64le-linux" = "271a0aa9c0a1dc2c84772fba33c9c6b97588d35eccf6757de6974c433b6e7874";
      "s390x-linux"       = "e8ec8adaaae2eab091500c257c7b18acf5e9556b4910df8290600bd7f723fdc1";
    }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    runHook preInstall

    install -D ibmcloud $out/bin/ibmcloud
    mkdir -p $out/share/ibmcloud
    cp LICENSE NOTICE $out/share/ibmcloud
    export HOME=$(mktemp -d)
    installShellCompletion --cmd ibmcloud --bash <($out/bin/ibmcloud --generate-bash-completion)

    runHook postInstall
  '';

  meta = with lib; {
    description = "Command line client for IBM Cloud";
    homepage = "https://cloud.ibm.com/docs/cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ emilytrau ];
    platforms = [ "x86_64-linux" "aarch64-linux" "i686-linux" "powerpc64le-linux" "s390x-linux" ] ++ platforms.darwin;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "ibmcloud";
  };
})
