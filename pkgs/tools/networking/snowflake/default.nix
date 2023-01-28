{ lib, buildGoModule, fetchFromGitLab }:

buildGoModule rec {
  pname = "snowflake";
  version = "2.5.0";

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    group = "tpo";
    owner = "anti-censorship/pluggable-transports";
    repo = "snowflake";
    rev = "v${version}";
    sha256 = "sha256-7iwRbik3hUj6Zv3tqLKqhGUIag6OnWRhpWqW6NTI+FU=";
  };

  vendorHash = "sha256-wHLYVf8QurMbmdLNkTFGgmncOJlJHZF8PwYTUniXOGY=";

  meta = with lib; {
    description = "System to defeat internet censorship";
    homepage = "https://snowflake.torproject.org/";
    changelog = "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake/-/raw/v${version}/ChangeLog";
    maintainers = with maintainers; [ lourkeur ];
    license = licenses.bsd3;
  };
}
