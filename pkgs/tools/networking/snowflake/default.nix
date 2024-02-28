{ lib, buildGoModule, fetchFromGitLab }:

buildGoModule rec {
  pname = "snowflake";
  version = "2.9.1";

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    group = "tpo";
    owner = "anti-censorship/pluggable-transports";
    repo = "snowflake";
    rev = "v${version}";
    sha256 = "sha256-LDr/Fzg1fC2lf7W+yTD1y5q4C2pPXZz+ZJf9sI1BxcQ=";
  };

  vendorHash = "sha256-IT2+5HmgkV6BKPEARkCZbULyVr7VDLtwGUCF22YuodA=";

  meta = with lib; {
    description = "System to defeat internet censorship";
    homepage = "https://snowflake.torproject.org/";
    changelog = "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake/-/raw/v${version}/ChangeLog";
    maintainers = with maintainers; [ bbjubjub yayayayaka ];
    license = licenses.bsd3;
  };
}
