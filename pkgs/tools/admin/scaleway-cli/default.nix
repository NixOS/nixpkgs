{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "scaleway-cli";
<<<<<<< HEAD
  version = "2.20.0";
=======
  version = "2.14.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "scaleway";
    repo = "scaleway-cli";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-zKqYbvSawu+xtDCxe31ERrjCMo4WLimbwAQX9mWvI7k=";
  };

  vendorHash = "sha256-UR7ZohQeLWux9AAvOUgtPA4F/qZXlx1vNjYrwal+Sac=";
=======
    sha256 = "sha256-NAo+nI4oaWTFqBfIHmkWGVYlFz5WjImvF3pfOFmw+cM=";
  };

  vendorHash = "sha256-iJLOkwXjfapZHGJ47raxmSW11HYsuB3ahEGDx2hFY10=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-w"
    "-extldflags"
    "-static"
    "-X main.Version=${version}"
    "-X main.GitCommit=ref/tags/${version}"
    "-X main.GitBranch=HEAD"
    "-X main.BuildDate=unknown"
  ];

  # some tests require network access to scaleway's API, failing when sandboxed
  doCheck = false;

  meta = with lib; {
    description = "Interact with Scaleway API from the command line";
    homepage = "https://github.com/scaleway/scaleway-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ nickhu techknowlogick ];
  };
}
