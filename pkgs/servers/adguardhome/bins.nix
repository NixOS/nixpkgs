{ fetchurl, fetchzip }:
{
x86_64-darwin = fetchzip {
  sha256 = "sha256-uviTmopXz7OYVr4H2M/dFOMw0vD5P+3t5CChSL2HyrE=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.56/AdGuardHome_darwin_amd64.zip";
};
aarch64-darwin = fetchzip {
  sha256 = "sha256-P9n6H8YmttcZE5E/7nw/Bc+Gzb4nHbs3L/2pgdqUyFw=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.56/AdGuardHome_darwin_arm64.zip";
};
i686-linux = fetchurl {
  sha256 = "sha256-JPhx1Hqu5o3K4bBulStedLZexCtZhgZNgzvGTqUn3XY=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.56/AdGuardHome_linux_386.tar.gz";
};
x86_64-linux = fetchurl {
  sha256 = "sha256-BEqPo3jeLukMnykO+6GNZ93bplDCOcV33BOHleQLWDI=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.56/AdGuardHome_linux_amd64.tar.gz";
};
aarch64-linux = fetchurl {
  sha256 = "sha256-JxitRduWdp4uJCcoR7FA26prDIc68CzsFOviehxDRxI=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.56/AdGuardHome_linux_arm64.tar.gz";
};
armv6l-linux = fetchurl {
  sha256 = "sha256-TdBDGSny3xWRrMG5MamrN26E/fOf7V9jHvxxbK+7BPU=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.56/AdGuardHome_linux_armv6.tar.gz";
};
armv7l-linux = fetchurl {
  sha256 = "sha256-mrBsebAKSelAMcuurAUiZdPKr2AGi9lnk1Dhz+PAm/0=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.56/AdGuardHome_linux_armv7.tar.gz";
};
}
