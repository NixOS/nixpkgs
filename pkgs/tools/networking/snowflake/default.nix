{ lib, buildGoModule, fetchgit }:

buildGoModule rec {
  pname = "snowflake";
  version = "2.2.0";

  src = fetchgit {
    url = "https://git.torproject.org/pluggable-transports/${pname}";
    rev = "v${version}";
    sha256 = "0iazamrfixv6yxc5m49adm97biq93pn6hwwpbh8yq558hrc6bh70";
  };

  vendorSha256 = "1v7cpg3kny0vqmdbgcc7i61wi5gx5wvrv0hmjykjrqgrvyq764c1";

  meta = with lib; {
    description = "System to defeat internet censorship";
    homepage = "https://snowflake.torproject.org/";
    maintainers = with maintainers; [ lourkeur ];
    license = licenses.bsd3;
  };
}
