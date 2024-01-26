{ lib, buildGoModule, fetchFromGitLab }:

buildGoModule rec {
  pname = "snowflake";
  version = "2.8.1";

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    group = "tpo";
    owner = "anti-censorship/pluggable-transports";
    repo = "snowflake";
    rev = "v${version}";
    sha256 = "sha256-DSXzw/7aBfh4uqLV2JrbrLitNgXcgEdcwxyIMolGEsE=";
  };

  vendorHash = "sha256-+f7gxswHCzBT5wqJNYdR1/uDZJNpEyHMWchA4X0aK+M=";

  meta = with lib; {
    description = "System to defeat internet censorship";
    homepage = "https://snowflake.torproject.org/";
    changelog = "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake/-/raw/v${version}/ChangeLog";
    maintainers = with maintainers; [ lourkeur yayayayaka ];
    license = licenses.bsd3;
  };
}
