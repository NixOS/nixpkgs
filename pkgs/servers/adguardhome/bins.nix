{ fetchurl, fetchzip }:
{
"x86_64-darwin" = fetchzip {
  sha256 = "sha256-vRfKVjFFy4cO/TrA+wEFYp6jcJSB/QDU3if0FDdYu+M=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.0/AdGuardHome_darwin_amd64.zip";
};
"i686-linux" = fetchurl {
  sha256 = "sha256-gWylZgCk+bGf1h2lTX2gRnW39P7C2ks0LH7anJW6JKw=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.0/AdGuardHome_linux_386.tar.gz";
};
"x86_64-linux" = fetchurl {
  sha256 = "sha256-g2DIeXwaqTTfshYyyDNHbOU57YUbuxXDKJHFqKFrqzw=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.0/AdGuardHome_linux_amd64.tar.gz";
};
"aarch64-linux" = fetchurl {
  sha256 = "sha256-PovduGRcfSUbhqX1cxRgMknN8mWJekjjpB0b1TE1//g=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.0/AdGuardHome_linux_arm64.tar.gz";
};
}
