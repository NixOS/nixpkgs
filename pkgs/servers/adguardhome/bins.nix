{ fetchurl, fetchzip }:
{
x86_64-darwin = fetchzip {
  sha256 = "sha256-pCyMhfDl371zzc3oXo+n09qNcxMtDQEqaqVW+YIrx28=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.20/AdGuardHome_darwin_amd64.zip";
};
aarch64-darwin = fetchzip {
  sha256 = "sha256-O2UTzaWaYTkeR3z/O8U/Btigjp/8gns4Y/D9yoX2Hns=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.20/AdGuardHome_darwin_arm64.zip";
};
i686-linux = fetchurl {
  sha256 = "sha256-ao/uebGho3CafFEcCfcS+awsC9lO/6z1UL57Yvr/q14=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.20/AdGuardHome_linux_386.tar.gz";
};
x86_64-linux = fetchurl {
  sha256 = "sha256-KJIogRRlZFPy3jBb9JeEA7xgZkl9/97cA13rBK6/1fI=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.20/AdGuardHome_linux_amd64.tar.gz";
};
aarch64-linux = fetchurl {
  sha256 = "sha256-r8gqUa9dULAYPUB64X4aqyaNf0CpckUNIsWl+VylhaM=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.20/AdGuardHome_linux_arm64.tar.gz";
};
}
