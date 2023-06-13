{ fetchurl, fetchzip }:
{
x86_64-darwin = fetchzip {
  sha256 = "sha256-W2XSIXrRuNsFGEdiGXD/7aUEShSwYhGp1yvdTXDg7Xc=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.31/AdGuardHome_darwin_amd64.zip";
};
aarch64-darwin = fetchzip {
  sha256 = "sha256-hqjuITqHNNZCDX+9ox8WLxrSoXeFZdaaSd1/RXTm2fM=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.31/AdGuardHome_darwin_arm64.zip";
};
i686-linux = fetchurl {
  sha256 = "sha256-rn8q3N4VT+xjss6OWYlW9DtAy+xfaQoriY0IuMIva6Y=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.31/AdGuardHome_linux_386.tar.gz";
};
x86_64-linux = fetchurl {
  sha256 = "sha256-OdGccAnlo0gGQB0IWFQX9PKz03BeUjeKwKvTjYKS5kU=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.31/AdGuardHome_linux_amd64.tar.gz";
};
aarch64-linux = fetchurl {
  sha256 = "sha256-EKWlhwgksmQv5OXme/4VHVFSREOsI2PGmWj9ArBukPw=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.31/AdGuardHome_linux_arm64.tar.gz";
};
armv6l-linux = fetchurl {
  sha256 = "sha256-eRdAyyNGTzn0oQ/cYcrZ0LAxUjih77yHx4O/1gm+YvY=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.31/AdGuardHome_linux_armv6.tar.gz";
};
armv7l-linux = fetchurl {
  sha256 = "sha256-p5SHPpl33Q8JGmqRBEFJD84VcueFmSXwbp3RssRsJIg=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.31/AdGuardHome_linux_armv7.tar.gz";
};
}
