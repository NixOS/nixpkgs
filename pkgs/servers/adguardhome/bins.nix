{ fetchurl, fetchzip }:
{
x86_64-darwin = fetchzip {
  sha256 = "sha256-z7QFnx414sdGazUZIenAVA+7LcSZT0tTb/ldv1SGV3Q=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.7/AdGuardHome_darwin_amd64.zip";
};
aarch64-darwin = fetchzip {
  sha256 = "sha256-Pbl7YaDVxdER/ubOiPq54ASB4ILnH0B3GiQlQBe7gFs=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.7/AdGuardHome_darwin_arm64.zip";
};
i686-linux = fetchurl {
  sha256 = "sha256-P2PsSdpW5i2hwBPUKb+viYewlVHTER/eBkwPp3koawo=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.7/AdGuardHome_linux_386.tar.gz";
};
x86_64-linux = fetchurl {
  sha256 = "sha256-cbTlVBlGdFgEz2b6pb0SJ7yUf4wFXnZwLCkmvX75FzU=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.7/AdGuardHome_linux_amd64.tar.gz";
};
aarch64-linux = fetchurl {
  sha256 = "sha256-TKZ3bOM5oq30GtLn9ifNyY6+2Li4nf1+r2L0ExG/10c=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.7/AdGuardHome_linux_arm64.tar.gz";
};
}
