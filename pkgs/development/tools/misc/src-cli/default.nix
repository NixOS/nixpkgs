{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "src-cli";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = pname;
    rev = version;
    sha256 = "sha256-cd96ddFtPOMATI0MEMFH399/y7SZeASetVhvRt0P38A=";
  };

  vendorSha256 = "sha256-ll/Q7hZJngOGG/Jl79KvEIHQ+ARDxFD7KHY3nSokRi0=";

  subPackages = [ "cmd/src" ];

  CGO_ENABLED = 0;

  ldflags = [ "-X github.com/sourcegraph/src-cli/internal/version.BuildTag=${version}" ];

  meta = with lib; {
    description = "Command line interface to Sourcegraph";
    homepage = "https://github.com/sourcegraph/src-cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "src";
  };
}
