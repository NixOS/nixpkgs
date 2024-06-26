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
  version = "2.17.0";

  src = fetchurl {
    url = "https://download.clis.cloud.ibm.com/ibm-cloud-cli/${finalAttrs.version}/binaries/IBM_Cloud_CLI_${finalAttrs.version}_${platform}.tgz";
    sha256 =
      {
        "x86_64-darwin" = "18f0dylgwwn9p1jmchqhq061s435n85qr2872i532whbrziwwjf3";
        "aarch64-darwin" = "1rid6rv601z4ayd3yi5srqbfn5bspypxarikvm563ygxawh1bxyi";
        "x86_64-linux" = "0ry8ix5id2zk04w9d9581g127f9jpj7bwg3x0pk3n9yfwn61g96d";
        "aarch64-linux" = "0s5jaqhyl234670q1mg89in2g5b9w3gzvnzl8qmlmgqkaxvzxj94";
        "i686-linux" = "0iw8y7iy9yx7y8v8b2wfl24f2rv9r20yj7l4sislxspfyvqv54p2";
        "powerpc64le-linux" = "19ac0na163l9h7ygbf3jwwv7zf0wagqvn6kcdh871c690i86wg9z";
        "s390x-linux" = "1zvy28jpxijzgdbr9q4rfyx6mk295mqp4nk8z299nm9ryk4q81lv";
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
