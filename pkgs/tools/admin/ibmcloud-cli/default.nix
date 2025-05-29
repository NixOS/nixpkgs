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
  version = "2.34.0";

  src = fetchurl {
    url = "https://download.clis.cloud.ibm.com/ibm-cloud-cli/${finalAttrs.version}/binaries/IBM_Cloud_CLI_${finalAttrs.version}_${platform}.tgz";
    hash =
      {
        "x86_64-darwin" = "sha256-6E+yUqpX8kp/T4jxAWwkBUsCQh31vwJGw3wnqkUs3Js=";
        "aarch64-darwin" = "sha256-CK0fUIYDVx25EzXGdhexaChVxkifSn6BKtZTQB5wl1o=";
        "x86_64-linux" = "sha256-xYuVEkgbVQNdR/v9C0Do9wMeOYlfntRJaen/XaHMJvQ=";
        "aarch64-linux" = "sha256-MXr6NpO3XhrCbcss3Y+GzkbgQ07iOzmp99lAtfZ8YMk=";
        "i686-linux" = "sha256-1oL+jn3KTfIE+2oW4i8+RUr/c9/Ew/H7PToe/l19C5s=";
        "powerpc64le-linux" = "sha256-hZADXpi9zxRB+wy4V4owQqmE3BYRSenNjlUfjWqBnow=";
        "s390x-linux" = "sha256-ayQZD4+6U6WLfIhbVy/HCATjhZYybk3/83ak7BruWQ8=";
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
    ] ++ lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "ibmcloud";
  };
})
