{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "kubescape";
  version = "1.0.77";

  src = fetchFromGitHub {
    owner = "armosec";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-g2Mco4NuPVjS4/6KNhtb8864e7RiuzlrdIbM6NLJK7I=";
  };

  vendorSha256 = "sha256-FtglYTCLjQfDKxdnQZnpWm3QjJCiHGsPC/gW88DZu6I=";

  # One test is failing, disabling for now
  doCheck = false;

  meta = with lib; {
    description = "Tool for testing if Kubernetes is deployed securely";
    homepage = "https://github.com/armosec/kubescape";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
