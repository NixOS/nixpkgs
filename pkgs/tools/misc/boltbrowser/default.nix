{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "boltbrowser";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "br0xen";
    repo = pname;
    rev = version;
    sha256 = "sha256-Obfhxe0AI5m4UTvs28PMOrBxWuwMW7FY4DMI80Ez0Ws=";
  };

  vendorSha256 = "sha256-G47vTP2EBM0fa1lCma6gQGMlkb6xe620hYwZYcSpSPQ=";

  meta = with lib; {
    description = "CLI Browser for BoltDB files";
    homepage = "https://github.com/br0xen/boltbrowser";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
