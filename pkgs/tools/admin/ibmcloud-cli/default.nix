{
  lib,
  stdenv,
  fetchurl,
  installShellFiles,
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
  version = "2.27.0";

  src = fetchurl {
    url = "https://download.clis.cloud.ibm.com/ibm-cloud-cli/${finalAttrs.version}/binaries/IBM_Cloud_CLI_${finalAttrs.version}_${platform}.tgz";
    sha256 =
      {
        "x86_64-darwin" = "0af5f110e094e7bf710c86d1e35af23ebbbc9ad8a4baf2a67895354b415618f6";
        "aarch64-darwin" = "1175977597102282cf7c1fd017ec4bdbc041ce367360204852d0798846cd21e4";
        "x86_64-linux" = "3c024bcb27519c8ed916ebc0266248249c127bbe93c343807e07d707cf159bb1";
        "aarch64-linux" = "bd2a6a3c4428061f17ac8b801b27d9700bf333284294e2834c34b4237f530256";
        "i686-linux" = "40dc32b2a76541847fd55b5b587105c90956468baf14016e4628bb8a2a3d73fa";
        "powerpc64le-linux" = "e758a60d7de32f4dfc8c944edb8e45bbed41de2fcb1e12bcf6b4e2b35d09f9d5";
        "s390x-linux" = "dbee26a3c4be2dcaad28b110e309283c141d55ac923b9d0420ac62b25c8eb9c0";
      }
      .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    runHook preInstall

    install -D ibmcloud $out/bin/ibmcloud
    mkdir -p $out/share/ibmcloud
    cp CF_CLI_Notices.txt CF_CLI_SLC_Notices.txt LICENSE NOTICE $out/share/ibmcloud
    export HOME=$(mktemp -d)
    installShellCompletion --cmd ibmcloud --bash <($out/bin/ibmcloud --generate-bash-completion)

    runHook postInstall
  '';

  meta = with lib; {
    description = "Command line client for IBM Cloud";
    homepage = "https://cloud.ibm.com/docs/cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ emilytrau ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "i686-linux"
      "powerpc64le-linux"
      "s390x-linux"
    ] ++ platforms.darwin;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "ibmcloud";
  };
})
