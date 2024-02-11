{ lib, buildGoModule, fetchFromGitLab }:

buildGoModule rec {
  pname = "snowflake";
  version = "2.9.0";

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    group = "tpo";
    owner = "anti-censorship/pluggable-transports";
    repo = "snowflake";
    rev = "v${version}";
    sha256 = "sha256-h8T8kc7idZcfepVjhpX+0RIypFDp2nMt3ZZ61YmeLQk=";
  };

  vendorHash = "sha256-TSB0UDVD9ijOFgOmIh7ppnKJn/VWzejeDcb1+30+Mnc=";

  meta = with lib; {
    description = "System to defeat internet censorship";
    homepage = "https://snowflake.torproject.org/";
    changelog = "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake/-/raw/v${version}/ChangeLog";
    maintainers = with maintainers; [ lourkeur yayayayaka ];
    license = licenses.bsd3;
  };
}
