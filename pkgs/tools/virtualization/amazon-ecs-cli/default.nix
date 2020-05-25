{ stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "amazon-ecs-cli";
  version = "1.18.1";

  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url = "https://s3.amazonaws.com/amazon-ecs-cli/ecs-cli-linux-amd64-v${version}";
        sha256 = "1q0qsvxwz6mgslwzwslddxxv45v9wmlbbkxgyfz3dfkw6n6d1a2s";
      }
    else if stdenv.hostPlatform.system == "x86_64-darwin" then
      fetchurl {
        url = "https://s3.amazonaws.com/amazon-ecs-cli/ecs-cli-darwin-amd64-v${version}";
        sha256 = "0hik88z5xm1pw6a3mxa6zpghdv47s6bg56srxv4azjinzdi59s3b";
      }
    else throw "Architecture not supported";

  dontUnpack = true;

  installPhase =
    ''
      mkdir -p $out/bin
      cp $src $out/bin/ecs-cli
      chmod +x $out/bin/ecs-cli
    '';  # */

  meta = with stdenv.lib; {
    homepage = "https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ECS_CLI.html";
    description = "The Amazon ECS command line interface";
    longDescription = "The Amazon Elastic Container Service (Amazon ECS) command line interface (CLI) provides high-level commands to simplify creating, updating, and monitoring clusters and tasks from a local development environment.";
    license = licenses.asl20;
    maintainers = with maintainers; [ Scriptkiddi ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
