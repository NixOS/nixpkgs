{ fetchurl, fetchzip }:
{
x86_64-darwin = fetchzip {
  sha256 = "sha256-hGa1SrueZWGokeJb+p/6eaYv1AP1a2TUiGo+rcJBw3Y=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.26/AdGuardHome_darwin_amd64.zip";
};
aarch64-darwin = fetchzip {
  sha256 = "sha256-wm8scjBaQuKJQu2OfYWDQqF2TLdPEZQEGSgaLzoGTb0=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.26/AdGuardHome_darwin_arm64.zip";
};
i686-linux = fetchurl {
  sha256 = "sha256-nie5WOeMajq8ucOwLHDXMG1FU7wBS3GTQHKCn0XjBCQ=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.26/AdGuardHome_linux_386.tar.gz";
};
x86_64-linux = fetchurl {
  sha256 = "sha256-Ai6QzmNrALHKxJIX5gx5GQiLlcpKRuT+ALxN0PDJQ9E=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.26/AdGuardHome_linux_amd64.tar.gz";
};
aarch64-linux = fetchurl {
  sha256 = "sha256-cJ7vvv4Yyo0r01eOuZI6jqc4LFmSDmVl84aJjwxkuR4=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.26/AdGuardHome_linux_arm64.tar.gz";
};
armv6l-linux = fetchurl {
  sha256 = "sha256-DfeSBIOO/vZQExbrqku28s8a9s22tfuojccIwe37tS4=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.26/AdGuardHome_linux_armv6.tar.gz";
};
armv7l-linux = fetchurl {
  sha256 = "sha256-OHoU8dP5b2jqFTfn4FCxL88HrQntcxZ5enMFr/YN1zI=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.26/AdGuardHome_linux_armv7.tar.gz";
};
}
