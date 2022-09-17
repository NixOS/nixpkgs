{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "serf";
  version = "0.10.0";
  rev = "a2bba5676d6e37953715ea10e583843793a0c507";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "serf";
    rev = "v${version}";
    sha256 = "sha256-5P2Pq2yzTGyw0hLwHdJB4YB+du0D8Q3MagRH3WXZ100=";
  };

  vendorSha256 = "sha256-2v2KcULgrwMRVGA91p7LJQPyQqwHLHhJa1WSivXHQG4=";

  subPackages = [ "cmd/serf" ];

  # These values are expected by version/version.go
  # https://github.com/hashicorp/serf/blob/7faa1b06262f70780c3c35ac25a4c96d754f06f3/version/version.go#L8-L22
  ldflags = lib.mapAttrsToList
    (n: v: "-X github.com/hashicorp/serf/version.${n}=${v}") {
      GitCommit = rev;
      Version = version;
      VersionPrerelease = "";
    };

  # There are no tests for cmd/serf.
  doCheck = false;

  meta = with lib; {
    description = "Service orchestration and management tool";
    longDescription = ''
      Serf is a decentralized solution for service discovery and orchestration
      that is lightweight, highly available, and fault tolerant.
    '';
    homepage = "https://www.serf.io";
    license = licenses.mpl20;
    maintainers = with maintainers; [ pradeepchhetri ];
  };
}
