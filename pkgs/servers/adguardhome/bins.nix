{ fetchurl, fetchzip }:
{
x86_64-darwin = fetchzip {
  sha256 = "sha256-R4Id8neiQypnj2hYYWEYSY10eJ7yId5k95aMnphvqEs=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.27/AdGuardHome_darwin_amd64.zip";
};
aarch64-darwin = fetchzip {
  sha256 = "sha256-EWQ02mIWYQfYEc8A9+U6N14v0h4kux8Cg7x4Xfj5uL0=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.27/AdGuardHome_darwin_arm64.zip";
};
i686-linux = fetchurl {
  sha256 = "sha256-Hmy3A2KuWk+Myqha/Typd6sY4rHI7kTAGLnz9XH1KRA=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.27/AdGuardHome_linux_386.tar.gz";
};
x86_64-linux = fetchurl {
  sha256 = "sha256-mNBv8F4BJHXJ86vnSM+0sfEkS3jB8TcMhM+6RJ5zgYM=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.27/AdGuardHome_linux_amd64.tar.gz";
};
aarch64-linux = fetchurl {
  sha256 = "sha256-2J06RvoKZJj3qRj6fg4l+S6soR+5gpCCupcJ75ggvD8=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.27/AdGuardHome_linux_arm64.tar.gz";
};
armv6l-linux = fetchurl {
  sha256 = "sha256-U3np5JP2/otbEkn+S5xtNO+RuUt6CkWMK4iftoTT460=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.27/AdGuardHome_linux_armv6.tar.gz";
};
armv7l-linux = fetchurl {
  sha256 = "sha256-y5/svgOJS3KbUJLbgjy9VOpog9W7xGyyx96JtdVyzjk=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.27/AdGuardHome_linux_armv7.tar.gz";
};
}
