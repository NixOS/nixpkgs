{
  lib,
  stdenv,
  fetchurl,
  installShellFiles,
  writableTmpDirAsHomeHook,
}:
let
  arch =
    with stdenv.hostPlatform;
    if isx86_64 then
      "amd64"
    else if isAarch64 then
      "arm64"
    else if isi686 then
      "386"
    else if isPower64 && isLittleEndian then
      "ppc64le"
    else if isS390x then
      "s390x"
    else
      throw "Unsupported arch: ${stdenv.hostPlatform.system}";
  platform =
    if stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64 then
      "macos_arm64"
    else if stdenv.hostPlatform.isDarwin then
      "macos"
    else
      "linux_${arch}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ibmcloud-cli";
  version = "2.39.0";

  src = fetchurl {
    url = "https://download.clis.cloud.ibm.com/ibm-cloud-cli/${finalAttrs.version}/binaries/IBM_Cloud_CLI_${finalAttrs.version}_${platform}.tgz";
    hash =
      {
        "x86_64-darwin" = "sha256-e8ta/PQUaga5rPzAVtUC7JGiYI8wLn08FriyVB1xFbA=";
        "aarch64-darwin" = "sha256-PEw0W2xqkCAFTDM2nXFy1Xb5rV/smhouH5WLUP8QzWg=";
        "x86_64-linux" = "sha256-A0Jt2mIN6w9MYak6mw49yKhsid7dNVwVy/7WseLBsiw=";
        "aarch64-linux" = "sha256-LQXb/zyTQw3b+3fxDe76mmWJQo3DaCZwrpGekXKs6bk=";
        "i686-linux" = "sha256-v/U8Ko4nnI9vlU83Y9Fym5OyCU/2s+UiQbtEBbiO1CQ=";
        "powerpc64le-linux" = "sha256-eS1d1BxvTpb1rYH+Ca6OqrFqXZewjq6oJ5+Drv6PRjw=";
        "s390x-linux" = "sha256-UM9UiVSv2/xcJEOGOtKP5uFYf4qEC7UdryQrxBjlqvY=";
      }
      .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  nativeBuildInputs = [
    installShellFiles
    writableTmpDirAsHomeHook
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 ibmcloud $out/bin/ibmcloud
    mkdir -p $out/share/ibmcloud
    cp LICENSE NOTICE $out/share/ibmcloud
    installShellCompletion --cmd ibmcloud --bash <($out/bin/ibmcloud --generate-bash-completion)

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Command line client for IBM Cloud";
    homepage = "https://cloud.ibm.com/docs/cli";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ emilytrau ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "i686-linux"
      "powerpc64le-linux"
      "s390x-linux"
    ]
    ++ lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "ibmcloud";
  };
})
