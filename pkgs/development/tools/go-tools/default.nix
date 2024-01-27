{ buildGoModule
, lib
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "go-tools";
  version = "2023.1.6";

  src = fetchFromGitHub {
    owner = "dominikh";
    repo = "go-tools";
    rev = version;
    sha256 = "sha256-Ecp3A3Go7mp8/ghMjTGqCNlRkCeEAb3fzRuwahWcM2I=";
  };

  vendorHash = "sha256-dUO2Iw+RYk8s+3IV2/TSKjaX61YkD/AROq3177r+wKE=";

  excludedPackages = [ "website" ];

  doCheck = false;

  meta = with lib; {
    description = "A collection of tools and libraries for working with Go code, including linters and static analysis";
    homepage = "https://staticcheck.io";
    license = licenses.mit;
    maintainers = with maintainers; [ rvolosatovs kalbasit smasher164 ];
  };
}
