{ lib, fetchgit, buildGoModule }:

buildGoModule rec {
  pname = "obfs4";
  version = "0.0.13";

  src = fetchgit {
    url = "https://github.com/Yawning/obfs4";
    rev = "${pname}proxy-${version}";
    sha256 = "1jqwjg3a2pcadnbip9nq3h2xwhpdf4gg6nhsayyzdx22fri6x3pv";
  };

  vendorSha256 = "sha256-7NF3yMouhjSM9SBNKHkeWV7qy0XTGnepEX28kBpbgdk=";

  meta = with lib; {
    description = "A pluggable transport proxy";
    homepage = "https://www.torproject.org/projects/obfsproxy";
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
