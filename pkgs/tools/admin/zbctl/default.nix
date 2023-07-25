{ lib
, stdenvNoCC
, fetchurl
}:

stdenvNoCC.mkDerivation rec {
  pname = "zbctl";
  version = "8.0.6";

  src = if stdenvNoCC.hostPlatform.system == "x86_64-darwin" then fetchurl {
    url = "https://github.com/camunda/zeebe/releases/download/${version}/zbctl.darwin";
    sha256 = "17hfjrcr6lmw91jq24nbw5yz61x6larmx39lyfj6pwlz0710y13p";
  } else if stdenvNoCC.hostPlatform.system == "x86_64-linux" then fetchurl {
    url = "https://github.com/camunda/zeebe/releases/download/${version}/zbctl";
    sha256 = "1xng11x7wcjvc0vipdrqyn97aa4jlgcp7g9aw4d36fw0xp9p47kp";
  } else throw "Unsupported platform ${stdenvNoCC.hostPlatform.system}";

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
    platforms = [ "x86_64-darwin" "x86_64-linux" ];
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
  };
}
