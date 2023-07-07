{ lib, buildGoModule, fetchFromGitLab }:

buildGoModule rec {
  pname = "snowflake";
  version = "2.5.1";

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    group = "tpo";
    owner = "anti-censorship/pluggable-transports";
    repo = "snowflake";
    rev = "v${version}";
    sha256 = "sha256-r2NRIb6qbA1B5HlVNRqa9ongQpyiyPskhembPHX3Lgc=";
  };

  vendorHash = "sha256-dnfm4KiVD89bnHV7bfw5aXWHGdcH9JBdrtvuS6s8N5w=";

  meta = with lib; {
    description = "System to defeat internet censorship";
    homepage = "https://snowflake.torproject.org/";
    changelog = "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake/-/raw/v${version}/ChangeLog";
    maintainers = with maintainers; [ lourkeur ];
    license = licenses.bsd3;
  };
}
