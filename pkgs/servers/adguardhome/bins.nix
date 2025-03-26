{ fetchurl, fetchzip }:
{
x86_64-darwin = fetchzip {
  sha256 = "sha256-IuMTJ/n77UswO3cRwg9Cqf5do+T6oQbTIjB86J84CVU=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.59/AdGuardHome_darwin_amd64.zip";
};
aarch64-darwin = fetchzip {
  sha256 = "sha256-sLTdansfYpTaHVzeGYe17eUYzeJH8ZHDWZWRYIJbwBI=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.59/AdGuardHome_darwin_arm64.zip";
};
i686-linux = fetchurl {
  sha256 = "sha256-8lyOMCHLDoSdjOsrBg1foFEbHtsqcJS3Bqa/vPSCpPU=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.59/AdGuardHome_linux_386.tar.gz";
};
x86_64-linux = fetchurl {
  sha256 = "sha256-R69nP+02XicEhUxqrc0sI5E0Eedu/OMbe88WdVu4B5c=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.59/AdGuardHome_linux_amd64.tar.gz";
};
aarch64-linux = fetchurl {
  sha256 = "sha256-78fS5+BQevEmnzb58EJ0+Ql/o/4K4fDBjSvlhv9FLFw=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.59/AdGuardHome_linux_arm64.tar.gz";
};
armv6l-linux = fetchurl {
  sha256 = "sha256-5ad5TLj1FJEoByyaMdZUqFz2UloBH9QzNEVgI+Mpubg=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.59/AdGuardHome_linux_armv6.tar.gz";
};
armv7l-linux = fetchurl {
  sha256 = "sha256-wK6a81h/0yTOwYsO4EITkC+zzSaFlwh+p8+3GquOIaA=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.59/AdGuardHome_linux_armv7.tar.gz";
};
}
