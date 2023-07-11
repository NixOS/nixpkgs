{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gron";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "tomnomnom";
    repo = "gron";
    rev = "v${version}";
    sha256 = "sha256-ZkAfAQsaFX7npyDcBDFS4Xa8kOMVH6yGfxGD7c0iQ+o=";
  };

  vendorSha256 = "sha256-K/QAG9mCIHe7PQhex3TntlGYAK9l0bESWk616N97dBs=";

  meta = with lib; {
    description = "Make JSON greppable!";
    longDescription = ''
      gron transforms JSON into discrete assignments to make it easier to grep
      for what you want and see the absolute 'path' to it. It eases the
      exploration of APIs that return large blobs of JSON but have terrible
      documentation.
    '';
    homepage = "https://github.com/tomnomnom/gron";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz SuperSandro2000 ];
  };
}
