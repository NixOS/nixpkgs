{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "amazon-ecs-cli";
  version = "1.21.0";

  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url = "https://s3.amazonaws.com/amazon-ecs-cli/ecs-cli-linux-amd64-v${version}";
        sha256 = "sEHwhirU2EYwtBRegiIvN4yr7VKtmy7e6xx5gZOkuY0=";
      }
    else if stdenv.hostPlatform.system == "x86_64-darwin" then
      fetchurl {
        url = "https://s3.amazonaws.com/amazon-ecs-cli/ecs-cli-darwin-amd64-v${version}";
        sha256 = "1viala49sifpcmgn3jw24h5bkrlm4ffadjiqagbxj3lr0r78i9nm";
      }
    else
      throw "Architecture not supported";

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/ecs-cli
    chmod +x $out/bin/ecs-cli
  ''; # */

  meta = with lib; {
    homepage = "https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ECS_CLI.html";
    description = "The Amazon ECS command line interface";
    longDescription = "The Amazon Elastic Container Service (Amazon ECS) command line interface (CLI) provides high-level commands to simplify creating, updating, and monitoring clusters and tasks from a local development environment.";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.asl20;
    maintainers = with maintainers; [ Scriptkiddi ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
    mainProgram = "ecs-cli";
  };
}
