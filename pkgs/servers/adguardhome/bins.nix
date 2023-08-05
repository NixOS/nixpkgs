{ fetchurl, fetchzip }:
{
x86_64-darwin = fetchzip {
  sha256 = "sha256-7GoW0Re4NZa31mmNPto9fCVzKCl5ymUYQCwmDfuAnIc=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.35/AdGuardHome_darwin_amd64.zip";
};
aarch64-darwin = fetchzip {
  sha256 = "sha256-A3EGk+dsh1/m4rAWKNq6va75pA4OFLo9kSLb0b/1uZA=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.35/AdGuardHome_darwin_arm64.zip";
};
i686-linux = fetchurl {
  sha256 = "sha256-8OIxMXjCZEurxInuDRAzEZ/Vjn1ixzZRMqXiSKgx7GE=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.35/AdGuardHome_linux_386.tar.gz";
};
x86_64-linux = fetchurl {
  sha256 = "sha256-japMeJETDPy0RaxJOs6dDktQfTZ1sLB4jotxLYZhxfc=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.35/AdGuardHome_linux_amd64.tar.gz";
};
aarch64-linux = fetchurl {
  sha256 = "sha256-E1MsoM3ZDaEPFLvXWt/+0hv8CVu2v9xlX0rvh4vmj6Y=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.35/AdGuardHome_linux_arm64.tar.gz";
};
armv6l-linux = fetchurl {
  sha256 = "sha256-LovoihsVGtDif7sSqS3CE3QXNv2v2aSLr/x9sq2j78E=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.35/AdGuardHome_linux_armv6.tar.gz";
};
armv7l-linux = fetchurl {
  sha256 = "sha256-ArTTEWD0yYLRrX8jytkMtKWLbEfr90O4i73dMjA+sdE=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.35/AdGuardHome_linux_armv7.tar.gz";
};
}
