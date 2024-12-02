{ fetchurl, fetchzip }:
{
x86_64-darwin = fetchzip {
  sha256 = "sha256-RcZqONyExyRue967ZmWULBad3OxaKRZWze5Ayu2poTM=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.54/AdGuardHome_darwin_amd64.zip";
};
aarch64-darwin = fetchzip {
  sha256 = "sha256-oPtjAIyQAFphSYAFXMzLfTV0E0aRyeA04dmtIl+U22M=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.54/AdGuardHome_darwin_arm64.zip";
};
i686-linux = fetchurl {
  sha256 = "sha256-Q3LTAqh0gJRB51D14/DZE+SlBDH7jCdoZ5D/yWnwA2o=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.54/AdGuardHome_linux_386.tar.gz";
};
x86_64-linux = fetchurl {
  sha256 = "sha256-ALqwcq0QVVpDG+eHI7xU8NocTwyFaNTcdozddm7bB+Q=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.54/AdGuardHome_linux_amd64.tar.gz";
};
aarch64-linux = fetchurl {
  sha256 = "sha256-mBESEcSVKcfm25mmO/+CA8C93PefM/BKtOCUtrliwfw=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.54/AdGuardHome_linux_arm64.tar.gz";
};
armv6l-linux = fetchurl {
  sha256 = "sha256-Y4O/OXv6dVXpqVMt+uhH1g3Qm/qV9N2P00ftntXwQ8Y=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.54/AdGuardHome_linux_armv6.tar.gz";
};
armv7l-linux = fetchurl {
  sha256 = "sha256-3x/oCNgXjAq+nJ8PVqc8GwX22EB7DydniRxqz1Acxlk=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.54/AdGuardHome_linux_armv7.tar.gz";
};
}
