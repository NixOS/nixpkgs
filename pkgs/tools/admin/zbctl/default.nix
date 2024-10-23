{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "zbctl";
  version = "8.6.0";

  src = fetchFromGitHub {
    owner = "camunda-community-hub";
    repo = "zeebe-client-go";
    rev = "v${version}";
    sha256 = "sha256-qr18JByNS2pKA+TCP3eCiFR2cugD0t+mD+4D+fUKhj8=";
  };

  vendorHash = null;
  doCheck = false;

  meta = with lib; {
    description = "Command line interface to interact with Camunda 8 and Zeebe";
    homepage = "https://github.com/camunda-community-hub/zeebe-client-go";
    downloadPage = "https://github.com/camunda-community-hub/zeebe-client-go/releases";
    changelog = "https://github.com/camunda-community-hub/zeebe-client-go/releases/tag/${version}";
    sourceProvenance = with sourceTypes; [binaryNativeCode];
    license = licenses.asl20;
    platforms = ["aarch64-darwin" "x86_64-darwin" "aarch64-linux" "x86_64-linux"];
    maintainers = with maintainers; [thetallestjj fred-drake];
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
