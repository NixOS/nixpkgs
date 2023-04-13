{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "envconsul";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "envconsul";
    rev = "v${version}";
    sha256 = "sha256-9X0mSEMaLGdchf9g5EyRUsn7z6cvbG4QBPoaris7RwQ=";
  };

  vendorSha256 = "sha256-Vunq3lsM1aSXNIr3ZMqE03f0jEI5BpWwMYhZ41tiB9M=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/hashicorp/envconsul/version.Name=envconsul"
  ];

  meta = with lib; {
    homepage = "https://github.com/hashicorp/envconsul/";
    description = "Read and set environmental variables for processes from Consul";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.mpl20;
    maintainers = with maintainers; [ pradeepchhetri ];
  };
}
