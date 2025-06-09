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
  version = "2.34.1";

  src = fetchurl {
    url = "https://download.clis.cloud.ibm.com/ibm-cloud-cli/${finalAttrs.version}/binaries/IBM_Cloud_CLI_${finalAttrs.version}_${platform}.tgz";
    hash =
      {
        "x86_64-darwin" = "sha256-+1Uf+OGZ5Mqo8OJN+ByxGO5OKm9XAxpbhBrNxyJmovs=";
        "aarch64-darwin" = "sha256-ByQ3eO2R8612aUaQyeXaJ4W8hiKk4YmDoQ3DdJn5n2o=";
        "x86_64-linux" = "sha256-gCnRyuUlHpr0b6hTwQBZ7V8WAjWG60+mly3uqfjlzrU=";
        "aarch64-linux" = "sha256-+Q87wqLKycSOusySpNfwVKhrrPOXL0teXEbN3QUC2ek=";
        "i686-linux" = "sha256-+8v/3qw2HYDxyEw8q+xshgF6Uo3lJRA5WloXagPPje4=";
        "powerpc64le-linux" = "sha256-3K4cgDOUZANMkCTU8AN9u/1F0ZsAjNBzEndRnz5Lxco=";
        "s390x-linux" = "sha256-54XEodccwQOR8/50m5qfQqcwIVCZAyQHuwYsn4Uq0Ms=";
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
