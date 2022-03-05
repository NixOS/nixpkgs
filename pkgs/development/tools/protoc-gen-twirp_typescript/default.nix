{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule {
  pname = "protoc-gen-twirp_typescript";
  version = "unstable-2021-03-29";

  src = fetchFromGitHub {
    owner = "larrymyers";
    repo = "protoc-gen-twirp_typescript";
    rev = "97fd63e543beb2d9f6a90ff894981affe0f2faf1";
    sha256 = "sha256-LfF/n96LwRX8aoPHzCRI/QbDmZR9yMhE5yGhFAqa8nA=";
  };

  vendorSha256 = "sha256-xZlP4rg1FMx6ddkKYlSdF6NrtY8xBZ3aEZSATgSf13M=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Protobuf Plugin for Generating a Twirp Typescript Client";
    homepage = "https://github.com/larrymyers/protoc-gen-twirp_typescript";
    license = licenses.mit;
    maintainers = with maintainers; [ jojosch ];
  };
}
