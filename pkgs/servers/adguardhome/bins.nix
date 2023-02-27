{ fetchurl, fetchzip }:
{
x86_64-darwin = fetchzip {
  sha256 = "sha256-mOn0RYWmGzIeHyVwVTGPUvFyVQ8Zu57KW7UkGMWRejA=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.25/AdGuardHome_darwin_amd64.zip";
};
aarch64-darwin = fetchzip {
  sha256 = "sha256-urdLtEOMJ2ZeaWezihpv5UU8Li2gnmYk6+gzn9E/3Nw=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.25/AdGuardHome_darwin_arm64.zip";
};
i686-linux = fetchurl {
  sha256 = "sha256-yWlo7adaQcPrM4zOPq5BLw6rZPYg2Qr2T1R7H8QZuvA=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.25/AdGuardHome_linux_386.tar.gz";
};
x86_64-linux = fetchurl {
  sha256 = "sha256-pD1vs4NHWByZmEozdgpzBXDeSzbEBouyawd41Emf8QE=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.25/AdGuardHome_linux_amd64.tar.gz";
};
aarch64-linux = fetchurl {
  sha256 = "sha256-BpknO9qL4Jo31d/vRXjuU/wJWfCVvLfgh6tZLG/6ipI=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.25/AdGuardHome_linux_arm64.tar.gz";
};
armv6l-linux = fetchurl {
  sha256 = "sha256-yUyRz/2hqvN8XkuzfMfG6ibYOb68WjJaqgAIAfoZH0s=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.25/AdGuardHome_linux_armv6.tar.gz";
};
armv7l-linux = fetchurl {
  sha256 = "sha256-MOvDKvq24+NFmgseZZA3zz0z6Vr/7OvO8sHpsDWvMuo=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.25/AdGuardHome_linux_armv7.tar.gz";
};
}
