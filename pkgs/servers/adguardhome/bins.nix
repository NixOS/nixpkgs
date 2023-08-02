{ fetchurl, fetchzip }:
{
x86_64-darwin = fetchzip {
  sha256 = "sha256-t+nFutMp1DwK7S9rQXcGQJjG/8plmlu5rJ1v5t8zJzE=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.34/AdGuardHome_darwin_amd64.zip";
};
aarch64-darwin = fetchzip {
  sha256 = "sha256-irL+9P+ZmGsAqbCOEtaC0u+YJykRgjG7dJx1qvP197w=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.34/AdGuardHome_darwin_arm64.zip";
};
i686-linux = fetchurl {
  sha256 = "sha256-6XEtCqlYIFh4Aw/Y+PxvLJmk5os5T0JPMnE2yTdT4Tw=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.34/AdGuardHome_linux_386.tar.gz";
};
x86_64-linux = fetchurl {
  sha256 = "sha256-o2EmkJ9jJAhQS25JCN15GBb+gGFOiKS/87PW2ge0YNg=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.34/AdGuardHome_linux_amd64.tar.gz";
};
aarch64-linux = fetchurl {
  sha256 = "sha256-YjecZiVwaK3/1In5uKSE5pF21YQJNpxEpPK0abNf3iQ=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.34/AdGuardHome_linux_arm64.tar.gz";
};
armv6l-linux = fetchurl {
  sha256 = "sha256-Or650AgvB/452wFiBLw1DezLIzYMSg0dQG66HeKypYg=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.34/AdGuardHome_linux_armv6.tar.gz";
};
armv7l-linux = fetchurl {
  sha256 = "sha256-i/jKr05o7UeXdEPusTQP0FeQoATl36ydDgtg5w/pMO4=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.34/AdGuardHome_linux_armv7.tar.gz";
};
}
