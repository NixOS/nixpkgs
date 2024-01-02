{ lib, buildGoModule, fetchFromGitLab }:

buildGoModule rec {
  pname = "snowflake";
  version = "2.7.0";

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    group = "tpo";
    owner = "anti-censorship/pluggable-transports";
    repo = "snowflake";
    rev = "v${version}";
    sha256 = "sha256-vurNOJuu9bKmyLM3Agr8wHwMybLrtrJFSrlrc+lWiWQ=";
  };

  vendorHash = "sha256-Bjd3HIVEQgrcBffcZPQhQygN/ZOPWTbN9oimmX4B1oQ=";

  meta = with lib; {
    description = "System to defeat internet censorship";
    homepage = "https://snowflake.torproject.org/";
    changelog = "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake/-/raw/v${version}/ChangeLog";
    maintainers = with maintainers; [ lourkeur yayayayaka ];
    license = licenses.bsd3;
  };
}
