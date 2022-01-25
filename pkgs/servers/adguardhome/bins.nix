{ fetchurl, fetchzip }:
{
"x86_64-darwin" = fetchzip {
  sha256 = "sha256-hB3TL1FocAtLpBe+Rv2Pyon4f1ld+Fqapz6TUQ0O1jU=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.3/AdGuardHome_darwin_amd64.zip";
};
"i686-linux" = fetchurl {
  sha256 = "sha256-ZPHmFxKLJ1oxT18P6FDv74/leCzlESTrhNYuC8T6u+I=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.3/AdGuardHome_linux_386.tar.gz";
};
"x86_64-linux" = fetchurl {
  sha256 = "sha256-yOvkEimDp646BCCFV2fnmVGe6R8geFlxtWLfPMVQ9Uk=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.3/AdGuardHome_linux_amd64.tar.gz";
};
"aarch64-linux" = fetchurl {
  sha256 = "sha256-ayNv2O0Ge3dT6YAN4SW/gsyoErCB3BJYsx/daMbGHjs=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.3/AdGuardHome_linux_arm64.tar.gz";
};
}
