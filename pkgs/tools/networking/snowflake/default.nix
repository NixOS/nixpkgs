{ lib, buildGoModule, fetchFromGitLab }:

buildGoModule rec {
  pname = "snowflake";
  version = "2.8.0";

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    group = "tpo";
    owner = "anti-censorship/pluggable-transports";
    repo = "snowflake";
    rev = "v${version}";
    sha256 = "sha256-/bip6hjYDTcSdtqeHxWcH7Yn4VepGVy3ki/kZWEQaPE=";
  };

  vendorHash = "sha256-dpOJE6FHaumL6vapigLTobS1r42DIFV8LHfVNvyZnsU=";

  meta = with lib; {
    description = "System to defeat internet censorship";
    homepage = "https://snowflake.torproject.org/";
    changelog = "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake/-/raw/v${version}/ChangeLog";
    maintainers = with maintainers; [ lourkeur yayayayaka ];
    license = licenses.bsd3;
  };
}
