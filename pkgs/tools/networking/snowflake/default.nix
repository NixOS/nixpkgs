{ lib, buildGoModule, fetchFromGitLab }:

buildGoModule rec {
  pname = "snowflake";
  version = "2.4.3";

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    group = "tpo";
    owner = "anti-censorship/pluggable-transports";
    repo = "snowflake";
    rev = "v${version}";
    sha256 = "sha256-hfB4mVakUmXH6Ac9ALZhriUtjz/RJ3RXwn50q9EWT+A=";
  };

  vendorHash = "sha256-66GqvwHPkMii5oXZV36ayYYkW1oaq5qTjkEA5BeS/5U=";

  meta = with lib; {
    description = "System to defeat internet censorship";
    homepage = "https://snowflake.torproject.org/";
    changelog = "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake/-/raw/v${version}/ChangeLog";
    maintainers = with maintainers; [ lourkeur ];
    license = licenses.bsd3;
  };
}
