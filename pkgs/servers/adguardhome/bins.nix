{ fetchurl, fetchzip }:
{
"x86_64-darwin" = fetchzip {
  sha256 = "sha256-ec1l4KxKJH4Iwg9hW+xlxLADGLN1vParYaWIw7nCfKA=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.106.3/AdGuardHome_darwin_amd64.zip";
};
"i686-linux" = fetchurl {
  sha256 = "sha256-9aGyC76WyzwHlAkR72kuNcd/68XdWWC3gfT92IuW2LY=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.106.3/AdGuardHome_linux_386.tar.gz";
};
"x86_64-linux" = fetchurl {
  sha256 = "sha256-qJMymTxmoPlIhuJD6zFBWWwzz+CFx+9+MOrRiFtA4IY=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.106.3/AdGuardHome_linux_amd64.tar.gz";
};
"aarch64-linux" = fetchurl {
  sha256 = "sha256-Z5hekNxeemqWsMu7n3UTmYCzdKp5Xsp9ku0G2LOqC80=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.106.3/AdGuardHome_linux_arm64.tar.gz";
};
}
