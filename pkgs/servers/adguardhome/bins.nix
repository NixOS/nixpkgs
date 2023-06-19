{ fetchurl, fetchzip }:
{
x86_64-darwin = fetchzip {
  sha256 = "sha256-DM/EhbKp2sM5OnvFrb2GcjhgMN+9kuVW33wHVSxcoLo=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.32/AdGuardHome_darwin_amd64.zip";
};
aarch64-darwin = fetchzip {
  sha256 = "sha256-rzGFcWou9+rDJuxqY6utnT54jAVLG2oj3Og8Fr8pibU=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.32/AdGuardHome_darwin_arm64.zip";
};
i686-linux = fetchurl {
  sha256 = "sha256-JkDQ9kmXuwcFXcfyDYwgI/NHqJYZj/PbhZfqlL0jvnw=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.32/AdGuardHome_linux_386.tar.gz";
};
x86_64-linux = fetchurl {
  sha256 = "sha256-YBE4yL63Ee1UmkE7pIbLKOLLhiY5DpN1t8i/ovQOKXo=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.32/AdGuardHome_linux_amd64.tar.gz";
};
aarch64-linux = fetchurl {
  sha256 = "sha256-Lj4eCcMgpy2AlGHKA/xRxZc2HV3llykWwVeTUlHXvyI=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.32/AdGuardHome_linux_arm64.tar.gz";
};
armv6l-linux = fetchurl {
  sha256 = "sha256-vAP/xc3IYMCtDbog2qB3kK5ftbsrk8meLD0IGx9tNa8=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.32/AdGuardHome_linux_armv6.tar.gz";
};
armv7l-linux = fetchurl {
  sha256 = "sha256-XiWExZZbtCdl/1Koi1dTKsiLl5xSwpI8LiGxjX2yT+A=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.32/AdGuardHome_linux_armv7.tar.gz";
};
}
