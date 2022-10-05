{ fetchurl, fetchzip }:
{
x86_64-darwin = fetchzip {
  sha256 = "sha256-H1oF++LfxSCEaz9UlLbcwM69zC9nw6DoOlKzG9R2XUk=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.15/AdGuardHome_darwin_amd64.zip";
};
aarch64-darwin = fetchzip {
  sha256 = "sha256-MYaiM8xOeT9NiVlKlE7cDecS1a6wcVW70gd6FsND7Ow=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.15/AdGuardHome_darwin_arm64.zip";
};
i686-linux = fetchurl {
  sha256 = "sha256-lzbHNWdmVFmDVZTKqW8h7ETdW6mUgfw9xSciePAMnhA=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.15/AdGuardHome_linux_386.tar.gz";
};
x86_64-linux = fetchurl {
  sha256 = "sha256-RnL4rGOuCb2rqyeXh1T6zyBpJwnsaBQeN1MxELM+Xp0=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.15/AdGuardHome_linux_amd64.tar.gz";
};
aarch64-linux = fetchurl {
  sha256 = "sha256-9gkFbZ4mCW/QpVe5AKt8RBkMZhhF2IhbL3nZC4iuQjE=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.15/AdGuardHome_linux_arm64.tar.gz";
};
}
