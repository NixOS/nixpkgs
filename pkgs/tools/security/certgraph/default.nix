{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "certgraph";
  version = "20210224";

  src = fetchFromGitHub {
    owner = "lanrat";
    repo = pname;
    rev = version;
    sha256 = "14l2bls25xwd8gnsmshc588br72rwz1s0gjnsnqksri4ksqkdqlz";
  };

  vendorSha256 = "1vih64z0zwmaflc0pwvnwyj5fhrc8qfp0kvrz73nnfpcrcan2693";

  meta = with lib; {
    description = "Intelligence tool to crawl the graph of certificate alternate names";
    homepage = "https://github.com/lanrat/certgraph";
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ fab ];
  };
}
