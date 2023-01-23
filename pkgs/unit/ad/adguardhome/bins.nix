{ fetchurl, fetchzip }:
{
x86_64-darwin = fetchzip {
  sha256 = "sha256-grxGXMskjpNHcL61xgX02ouxFodxnzuhORby0wcZM7E=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.22/AdGuardHome_darwin_amd64.zip";
};
aarch64-darwin = fetchzip {
  sha256 = "sha256-J98fqxPlr8XZMll63GC5G8SvzOS6egViHATKSKCfYQ4=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.22/AdGuardHome_darwin_arm64.zip";
};
i686-linux = fetchurl {
  sha256 = "sha256-09HyY9WL2vzA5L0nDG/ByHs/fWj+GiJUy3Rq9yWd4Ak=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.22/AdGuardHome_linux_386.tar.gz";
};
x86_64-linux = fetchurl {
  sha256 = "sha256-1mFOlerwTOLUQGiVX1nyFfMC1vl7W0c+P/xnPjNTrYE=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.22/AdGuardHome_linux_amd64.tar.gz";
};
aarch64-linux = fetchurl {
  sha256 = "sha256-eoITV5oAyGJBn607lfJgH/1C0dHkoEIvk3x6rKxKn+k=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.22/AdGuardHome_linux_arm64.tar.gz";
};
}
