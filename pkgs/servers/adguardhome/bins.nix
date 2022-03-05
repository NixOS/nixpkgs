{ fetchurl, fetchzip }:
{
"x86_64-darwin" = fetchzip {
  sha256 = "sha256-mKCqFMkTei7n/eI9s3aiAKc4jdnRA121TOizRHON1ic==";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.4/AdGuardHome_darwin_amd64.zip";
};
"i686-linux" = fetchurl {
  sha256 = "sha256-N+S2BWUskEHt5YjpncmiurdgQ6TN35TWN8Zv7bM3a5k=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.4/AdGuardHome_linux_386.tar.gz";
};
"x86_64-linux" = fetchurl {
  sha256 = "sha256-p665fB2lVSLpWIYlTNW+ZGOohpobdvOs0AIQ1l9BlmE=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.4/AdGuardHome_linux_amd64.tar.gz";
};
"aarch64-linux" = fetchurl {
  sha256 = "sha256-oomkIHeQDTNDp6A6CcMv2s89PkuKpGVV4iLCxcj0Xsc=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.4/AdGuardHome_linux_arm64.tar.gz";
};
}
