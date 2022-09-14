{ fetchurl, fetchzip }:
{
x86_64-darwin = fetchzip {
  sha256 = "sha256-uJQPC1YNvkd9SD6OQCANbWXlA/ebfG1PjYnLdVCyjlo=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.13/AdGuardHome_darwin_amd64.zip";
};
aarch64-darwin = fetchzip {
  sha256 = "sha256-oExdBohVLTw7w1nQbZZAHm10lpjBTOYJaLBsocWAhYI=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.13/AdGuardHome_darwin_arm64.zip";
};
i686-linux = fetchurl {
  sha256 = "sha256-mjaz08pn/+LfSQQD53QdqudIceXiGv+gZsJFy4lphF8=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.13/AdGuardHome_linux_386.tar.gz";
};
x86_64-linux = fetchurl {
  sha256 = "sha256-gAH5wE0rTaEhWxHdL41e2juNDaVJycREXNgc0VdjBlg=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.13/AdGuardHome_linux_amd64.tar.gz";
};
aarch64-linux = fetchurl {
  sha256 = "sha256-YHpvg8WkF9vlDtJUW6OfRzGJjamV0rzNJC4ALP7h+xQ=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.13/AdGuardHome_linux_arm64.tar.gz";
};
}
