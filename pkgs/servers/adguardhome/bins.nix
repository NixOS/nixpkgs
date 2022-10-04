{ fetchurl, fetchzip }:
{
x86_64-darwin = fetchzip {
  sha256 = "sha256-llVKoUAB5cIeRE79Lw5oAvR9rwXdtmALYEwiIg1vN9Q=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.14/AdGuardHome_darwin_amd64.zip";
};
aarch64-darwin = fetchzip {
  sha256 = "sha256-v6Dvs0Ny39tOO+f9JWadBa07QwKCC9gHU69+OMmPxXM=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.14/AdGuardHome_darwin_arm64.zip";
};
i686-linux = fetchurl {
  sha256 = "sha256-ofx16H6+tSTOEz+UuTXKzzVx3hREwW8EjEqAgXdnqQg=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.14/AdGuardHome_linux_386.tar.gz";
};
x86_64-linux = fetchurl {
  sha256 = "sha256-kftAZ2snv3xsrVPq3y5uJKwZhHtNO/VQL1LBh5yk/DA=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.14/AdGuardHome_linux_amd64.tar.gz";
};
aarch64-linux = fetchurl {
  sha256 = "sha256-JVy2dDZGfH+vZhNJ94wvoYY3I0tQA6CSZ/c1rBikZWw=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.14/AdGuardHome_linux_arm64.tar.gz";
};
}
