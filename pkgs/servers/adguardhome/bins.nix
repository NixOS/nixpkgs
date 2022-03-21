{ fetchurl, fetchzip }:
{
"x86_64-darwin" = fetchzip {
  sha256 = "sha256-bTbjkBHOjcI78+jyJJ1JGe/WrmTxXi5RRB1yQO2zuYw=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.5/AdGuardHome_darwin_amd64.zip";
};
"i686-linux" = fetchurl {
  sha256 = "sha256-wdzj7P+Hhm65i5hY4l2Ty486W473coZyZnCbzx9Poro=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.5/AdGuardHome_linux_386.tar.gz";
};
"x86_64-linux" = fetchurl {
  sha256 = "sha256-sZQe8rNYD0gBSpNeXS+4hbqoT5nUFbkQSI3c6VuQOC8=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.5/AdGuardHome_linux_amd64.tar.gz";
};
"aarch64-linux" = fetchurl {
  sha256 = "sha256-9JsGzFf03en2ClrodglREsYqrwr6j/vypsfEVaMzCTI=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.5/AdGuardHome_linux_arm64.tar.gz";
};
}
