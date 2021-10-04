{ lib, fetchgit, buildGoModule }:

buildGoModule rec {
  pname = "snowflake";
  version = "1.1.0";

  src = fetchgit {
    url = "https://git.torproject.org/pluggable-transports/snowflake.git";
    rev = "v${version}";
    sha256 = "0d5ddhg2p0mbcj1cmklwn04za2x1khxgm5x9qlsg1ywkn6ngnxad";
  };

  vendorSha256 = "15nzqibrymbbn6cwz3267jxk60xr5f6v3akwplhjzcc16bgrcx57";

  meta = with lib; {
    description = "A pluggable transport proxy";
    homepage = "https://snowflake.torproject.org";
    maintainers = with maintainers; [ witchof0x20 ];
    license = with lib.licenses; [
      # common/nat/nat.go is licensed under the Expat license
      mit
      # All other files are licensed under bsd3
      licenses.bsd3
    ];
  };
}
