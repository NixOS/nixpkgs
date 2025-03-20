{ fetchurl, fetchzip }:
{
x86_64-darwin = fetchzip {
  sha256 = "sha256-wNDPmB/RyTc3ZZWx7glhDx3aeWFrvcsiNv7hvsnWWu4=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.57/AdGuardHome_darwin_amd64.zip";
};
aarch64-darwin = fetchzip {
  sha256 = "sha256-gm9QHJFrCbKyEK6RsSKCeIQY2eYJIXO1n4vAkA3yatY=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.57/AdGuardHome_darwin_arm64.zip";
};
i686-linux = fetchurl {
  sha256 = "sha256-2TVrjG4C4uLsBUJoya4YxiOlTJlcmzPG6lUWcCj/PYE=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.57/AdGuardHome_linux_386.tar.gz";
};
x86_64-linux = fetchurl {
  sha256 = "sha256-E2bzQIYsRpijlJnjD+V3lh5a1nauD5aMVoI/9tHfrRM=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.57/AdGuardHome_linux_amd64.tar.gz";
};
aarch64-linux = fetchurl {
  sha256 = "sha256-0yedCjUkpye2Rly87a5Qdyfy8/kgrEOrHKpbZ0YhruM=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.57/AdGuardHome_linux_arm64.tar.gz";
};
armv6l-linux = fetchurl {
  sha256 = "sha256-RhPXB3G9iDmijTCsljXedJxqLr8Zna5IzU18KITU0m0=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.57/AdGuardHome_linux_armv6.tar.gz";
};
armv7l-linux = fetchurl {
  sha256 = "sha256-tAtuMWgy+HMUIMbKLQZOMVO7z65UuPIZnHpJr1IYpJw=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.57/AdGuardHome_linux_armv7.tar.gz";
};
}
