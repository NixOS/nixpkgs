{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "zbctl";
  version = "8.2.11";

  src =
    if stdenvNoCC.hostPlatform.system == "x86_64-darwin" then
      fetchurl {
        url = "https://github.com/camunda/zeebe/releases/download/${version}/zbctl.darwin";
        sha256 = "0390n6wmlmfwqf6fvw6wqg6hbrs7bm9x2cdaajlw87377lklypkf";
      }
    else if stdenvNoCC.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url = "https://github.com/camunda/zeebe/releases/download/${version}/zbctl";
        sha256 = "081hc0nynwg014lhsxxyin4rc2i9z6wh8q9i98cjjd8kgr41h096";
      }
    else
      throw "Unsupported platform ${stdenvNoCC.hostPlatform.system}";

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp $src $out/bin/zbctl
    chmod +x $out/bin/zbctl
    runHook postInstall
  '';

  meta = with lib; {
    description = "The command line interface to interact with Camunda 8 and Zeebe";
    homepage = "https://docs.camunda.io/docs/apis-clients/cli-client/";
    downloadPage = "https://github.com/camunda/zeebe/releases";
    changelog = "https://github.com/camunda/zeebe/releases/tag/${version}";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.asl20;
    platforms = [
      "x86_64-darwin"
      "x86_64-linux"
    ];
    maintainers = with maintainers; [ thetallestjj ];
    longDescription = ''
      A command line interface for Camunda Platform 8 designed to create and read resources inside a Zeebe broker.
      It can be used for regular development and maintenance tasks such as:
      * Deploying processes
      * Creating process instances and job workers
      * Activating, completing, or failing jobs
      * Updating variables and retries
      * Viewing cluster status
    '';
    mainProgram = "zbctl";
  };
}
