{ stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "amazon-ecs-cli-${version}";
  version = "1.13.1";

  src = fetchurl {
    url = "https://s3.amazonaws.com/amazon-ecs-cli/ecs-cli-linux-amd64-v${version}";
    sha256 = "0wiq32szmy2vk7yjjrcfisl9wrydcyiw986vhk0haidxkgw0gkv0";
  };

  unpackPhase = ":";

  installPhase =
    ''
      mkdir -p $out/bin
      cp $src $out/bin/ecs-cli
      chmod +x $out/bin/ecs-cli
    '';  # */

  meta = with stdenv.lib; {
    homepage = https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ECS_CLI.html;
    description = "The Amazon ECS command line interface";
    longDescription = "The Amazon Elastic Container Service (Amazon ECS) command line interface (CLI) provides high-level commands to simplify creating, updating, and monitoring clusters and tasks from a local development environment.";
    license = licenses.asl20;
    maintainers = with maintainers; [ Scriptkiddi ];
    platforms = [ "x86_64-linux" ];
  };
}

