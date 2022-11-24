{ fetchurl, fetchzip }:
{
x86_64-darwin = fetchzip {
  sha256 = "sha256-XzM+ZAlpT33AQd7etCXZQos9Ifg7oM9DkzncP+EBvoo=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.18/AdGuardHome_darwin_amd64.zip";
};
aarch64-darwin = fetchzip {
  sha256 = "sha256-9pMZVSqU6Rqet73Lg/JBzX1PWmR9nxUSmKD6E4fAxSw=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.18/AdGuardHome_darwin_arm64.zip";
};
i686-linux = fetchurl {
  sha256 = "sha256-AVFQpruoScSTFpsK3+7e1hXaJaKlK5dQ+8uga5+dHRY=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.18/AdGuardHome_linux_386.tar.gz";
};
x86_64-linux = fetchurl {
  sha256 = "sha256-ncVQc8zJy9i8TNmDIjLQh58I3gIfTLgDwctBFD1HR2I=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.18/AdGuardHome_linux_amd64.tar.gz";
};
aarch64-linux = fetchurl {
  sha256 = "sha256-tzc67MHg6idLW5b69zLZw/76tP6YEMlWNPosrsD4uTA=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.18/AdGuardHome_linux_arm64.tar.gz";
};
}
