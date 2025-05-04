{ fetchurl, fetchzip }:
{
  x86_64-darwin = fetchzip {
    sha256 = "sha256-/xwRH9+qJQ91z2alo2sBdnLs2Z2wXUMHqJvxagptx5U=";
    url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.61/AdGuardHome_darwin_amd64.zip";
  };
  aarch64-darwin = fetchzip {
    sha256 = "sha256-60uD8dH4Dqbey21HGx/PIzWBcN/00V1/oS1ubrucayY=";
    url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.61/AdGuardHome_darwin_arm64.zip";
  };
  i686-linux = fetchurl {
    sha256 = "sha256-RJeU+n46IMncX5MXDedw/7DSe6pISsTJEyfI5B1pEcY=";
    url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.61/AdGuardHome_linux_386.tar.gz";
  };
  x86_64-linux = fetchurl {
    sha256 = "sha256-jZV/U4DUw70J1xmZLM5+gqAgpUP7fdyw46Neq8fQxT0=";
    url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.61/AdGuardHome_linux_amd64.tar.gz";
  };
  aarch64-linux = fetchurl {
    sha256 = "sha256-TtD8KR92Mv3Z3nCz4xIT+FcuxwqgDTq3C1lGIELrEQU=";
    url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.61/AdGuardHome_linux_arm64.tar.gz";
  };
  armv6l-linux = fetchurl {
    sha256 = "sha256-MosFBi72sgdZshUzAxi/ht56VpeHMguRQawU3DI5Va8=";
    url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.61/AdGuardHome_linux_armv6.tar.gz";
  };
  armv7l-linux = fetchurl {
    sha256 = "sha256-7YFzd6z9eCGBHlyYgDiwE+cpQzEuQIHDYfbCopapYrw=";
    url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.61/AdGuardHome_linux_armv7.tar.gz";
  };
}
