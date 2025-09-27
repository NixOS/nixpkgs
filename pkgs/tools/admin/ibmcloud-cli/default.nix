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
  version = "2.37.0";

  src = fetchurl {
    url = "https://download.clis.cloud.ibm.com/ibm-cloud-cli/${finalAttrs.version}/binaries/IBM_Cloud_CLI_${finalAttrs.version}_${platform}.tgz";
    hash =
      {
        "x86_64-darwin" = "sha256-AQfeK8KWAo4+KCKFPZDYpiTEq0Cx1s0yA/kG5F1Tdms=";
        "aarch64-darwin" = "sha256-p3m9wjyE5QKS4ykqJRkbiK+ZRH/9XV9JAiAgbYKFnF8=";
        "x86_64-linux" = "sha256-vRAd+uzX0Dwa8yaPtUf28l5lIAcJsYBoq1TtmaXDEW0=";
        "aarch64-linux" = "sha256-6g3m7YwifAwC0FqiboHPBD0KO9s4pAroPoQAqMbsF5Q=";
        "i686-linux" = "sha256-yKJNeWmJr1anZPZbBP24dsPY/r8wDvfuL8EJ/IVVNcQ=";
        "powerpc64le-linux" = "sha256-AWFcD3lLao4xNU5OeADnc627ZJbYPEFrOltSWNg4lYI=";
        "s390x-linux" = "sha256-WrEew3OaSwbCKkuuagIIh/lpt3SaQb455bQO+VtwDwc=";
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
