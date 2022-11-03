{ fetchurl, fetchzip }:
{
x86_64-darwin = fetchzip {
  sha256 = "sha256-afHd6evLu478mnprzD3U1b/7pXYu1zBWc+9WlWaBlDs=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.17/AdGuardHome_darwin_amd64.zip";
};
aarch64-darwin = fetchzip {
  sha256 = "sha256-2tE7chJP+3PjedyvyU9iLWq52OuBG2XGkyWuQzDizXw=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.17/AdGuardHome_darwin_arm64.zip";
};
i686-linux = fetchurl {
  sha256 = "sha256-iJXzQ9ELOy9OglEqYHvd9JwM12XTCbX1PFzAp31aMLA=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.17/AdGuardHome_linux_386.tar.gz";
};
x86_64-linux = fetchurl {
  sha256 = "sha256-WMeDwSJrfmm4ZI84m3iNPzkg7kZE9oDwtngyXzh+rRw=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.17/AdGuardHome_linux_amd64.tar.gz";
};
aarch64-linux = fetchurl {
  sha256 = "sha256-9MGGzzPwX85iF228ibQ5NnTIxQ8dErD0+AOQGQpEKTs=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.17/AdGuardHome_linux_arm64.tar.gz";
};
}
