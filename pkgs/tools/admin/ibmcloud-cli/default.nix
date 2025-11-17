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
  version = "2.38.1";

  src = fetchurl {
    url = "https://download.clis.cloud.ibm.com/ibm-cloud-cli/${finalAttrs.version}/binaries/IBM_Cloud_CLI_${finalAttrs.version}_${platform}.tgz";
    hash =
      {
        "x86_64-darwin" = "sha256-yCGtJ8a2CzLkOF7A1ODRlww8xTmqCF/V4azv8eFdG3E=";
        "aarch64-darwin" = "sha256-5coVlypB5RHm5KFTO2xFcFpS9Zgd/CaWOYE6ZMcIfW8=";
        "x86_64-linux" = "sha256-0bxuF7kS07JrGPteUy4hze0C5A31hdSgpsDLWGR5Xps=";
        "aarch64-linux" = "sha256-lyBHbNTbdMqPtP/vK9YGITTHv0O8Tby163uhm33kTGE=";
        "i686-linux" = "sha256-YMVsffuEgbqeGymvrQFFyYIhZ3LzlOjQDFcVdDPm5hI=";
        "powerpc64le-linux" = "sha256-o49axCzFhlB4n34BdCYJRa7IMBRQLR3NShFmXKJeUKA=";
        "s390x-linux" = "sha256-sdS+mcsFfECrhdfl3Gugk6A74nh2olJGLtcD27Y8zcI=";
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
