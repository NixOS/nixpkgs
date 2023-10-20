{ fetchurl, fetchzip }:
{
x86_64-darwin = fetchzip {
  sha256 = "sha256-B3/b+CXolqnnHElZzfSbxUQcomEWh6KK9WU3y3HF8k0=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.46/AdGuardHome_darwin_amd64.zip";
};
aarch64-darwin = fetchzip {
  sha256 = "sha256-WfjV30vyUVyDeW4J9LbnTLKbMCoxkxRSzHoCSH3oY4U=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.46/AdGuardHome_darwin_arm64.zip";
};
i686-linux = fetchurl {
  sha256 = "sha256-DbLGJVmZSAyOAyl/d5i1NgRtg0Fd1WpULIqWyQ/K4FI=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.46/AdGuardHome_linux_386.tar.gz";
};
x86_64-linux = fetchurl {
  sha256 = "sha256-jTGy0BVShSBNNWH0mtj5YYbv+w/iFbMEzFPtH/sqq/8=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.46/AdGuardHome_linux_amd64.tar.gz";
};
aarch64-linux = fetchurl {
  sha256 = "sha256-UBEJa644Pifbnw3gY8ruqexLDgvKxnKECdIj3FHIwNA=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.46/AdGuardHome_linux_arm64.tar.gz";
};
armv6l-linux = fetchurl {
  sha256 = "sha256-n8hrfk2YFIs81+nsDY2JPcAgmWJYyze7VGYzjMRZ058=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.46/AdGuardHome_linux_armv6.tar.gz";
};
armv7l-linux = fetchurl {
  sha256 = "sha256-XaM0Mt4QhFoG0a+1az2QQ+KatV6NPzWec7zaENmvFqs=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.46/AdGuardHome_linux_armv7.tar.gz";
};
}
