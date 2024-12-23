{ fetchurl, fetchzip }:
{
  x86_64-darwin = fetchzip {
    sha256 = "sha256-+xZmMc5VOJ2GKvZdR0qDdwj+qze4r7eJFtZuLUkqZwE=";
    url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.55/AdGuardHome_darwin_amd64.zip";
  };
  aarch64-darwin = fetchzip {
    sha256 = "sha256-gIqPWHOl0bcZYmfujV3KnTrsZ8hWjN5KQDWq+aHNIn4=";
    url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.55/AdGuardHome_darwin_arm64.zip";
  };
  i686-linux = fetchurl {
    sha256 = "sha256-HWUTRPkaqk26A2eeN13DUNKBNM+jDBa5UuqjrYzPK5k=";
    url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.55/AdGuardHome_linux_386.tar.gz";
  };
  x86_64-linux = fetchurl {
    sha256 = "sha256-El/IAemoIyOgQYpmI1F84qTFteHT0H3ncYp2WxzZcJY=";
    url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.55/AdGuardHome_linux_amd64.tar.gz";
  };
  aarch64-linux = fetchurl {
    sha256 = "sha256-AHsQbTWH1mNafhRtpGY31g89jP07TZnL5fJvS0EbLDU=";
    url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.55/AdGuardHome_linux_arm64.tar.gz";
  };
  armv6l-linux = fetchurl {
    sha256 = "sha256-cpCgPLJEkgR0h5pduIEGP+sb58qZTljEeQn/w3Csz2Q=";
    url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.55/AdGuardHome_linux_armv6.tar.gz";
  };
  armv7l-linux = fetchurl {
    sha256 = "sha256-Nm09ih54jZEDMJCBJst43Sl2d6vVXCdFnkWBV4lehns=";
    url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.55/AdGuardHome_linux_armv7.tar.gz";
  };
}
