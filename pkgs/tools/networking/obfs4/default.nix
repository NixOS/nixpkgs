{ lib, fetchgit, buildGoModule }:

buildGoModule rec {
  pname = "obfs4";
  version = "0.0.11";

  src = fetchgit {
    url = "https://git.torproject.org/pluggable-transports/obfs4.git";
    rev = "refs/tags/${pname}proxy-${version}";
    sha256 = "sha256-VjJ/Pc1YjNB2iLnN/5CxuaxolcaR1IMWgoESMzOXU/g=";
  };

  vendorSha256 = "sha256-xGCK8biTYcrmKbsl6ZyCjpRrVP9x5xGrC3VcMsR7ETo=";

  meta = with lib; {
    description = "A pluggable transport proxy";
    homepage = "https://www.torproject.org/projects/obfsproxy";
    maintainers = with maintainers; [ thoughtpolice ];
    mainProgram = "obfs4proxy";
  };
}
