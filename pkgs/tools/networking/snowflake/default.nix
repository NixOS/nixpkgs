{ lib, buildGoModule, fetchgit }:

buildGoModule rec {
  pname = "snowflake";
  version = "2.3.1";

  src = fetchgit {
    url = "https://git.torproject.org/pluggable-transports/${pname}";
    rev = "v${version}";
    sha256 = "sha256-4/ZTLyST73krOL87am28TM+1mktchpoCSaASMqQl5e8=";
  };

  vendorSha256 = "sha256-a2Ng+D1I0v5odChM6XVVnNwea/0SOTOmdm2dqKaSU3s=";

  meta = with lib; {
    description = "System to defeat internet censorship";
    homepage = "https://snowflake.torproject.org/";
    maintainers = with maintainers; [ lourkeur ];
    license = licenses.bsd3;
  };
}
