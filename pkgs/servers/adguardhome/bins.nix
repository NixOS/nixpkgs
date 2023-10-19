{ fetchurl, fetchzip }:
{
x86_64-darwin = fetchzip {
  sha256 = "sha256-jIrzE1Je2dhMJuq3k8KL1VoHru5qaUAJCR3kumE9aO0=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.36/AdGuardHome_darwin_amd64.zip";
};
aarch64-darwin = fetchzip {
  sha256 = "sha256-9BgGGCP8n+5Op+S1/yT/kdMvmiNgKkkXLQmqF2plJZY=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.36/AdGuardHome_darwin_arm64.zip";
};
i686-linux = fetchurl {
  sha256 = "sha256-yPxLYXtH4bwQk2M2VTS5aJWTJciNaeXRRAcMBHuvkcA=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.36/AdGuardHome_linux_386.tar.gz";
};
x86_64-linux = fetchurl {
  sha256 = "sha256-sG64t1x70uKk844dT1g9GzJ+DgHuv7sUEBaVqoEmWOw=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.36/AdGuardHome_linux_amd64.tar.gz";
};
aarch64-linux = fetchurl {
  sha256 = "sha256-rUSfo1uJGbxx1n/VcLyq5zqiDo4g0caCpVcL2uZUSkE=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.36/AdGuardHome_linux_arm64.tar.gz";
};
armv6l-linux = fetchurl {
  sha256 = "sha256-ruICFAGEMXDeLvoOxHg2oEaYDHkoGZI+SozDXmmD9VU=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.36/AdGuardHome_linux_armv6.tar.gz";
};
armv7l-linux = fetchurl {
  sha256 = "sha256-mTGufMIKkj2R7QuNWKSKMt9KdwlZe9ORtJK5hIaeH/E=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.36/AdGuardHome_linux_armv7.tar.gz";
};
}
