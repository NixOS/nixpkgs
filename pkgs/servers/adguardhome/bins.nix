{ fetchurl, fetchzip }:
{
x86_64-darwin = fetchzip {
  sha256 = "sha256-r1ITe9Elt+UaCIQhgZiMvN1mFyipAVXq/zRWYfMMgxg=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.43/AdGuardHome_darwin_amd64.zip";
};
aarch64-darwin = fetchzip {
  sha256 = "sha256-y42mcgWvvYxTTEthzBkKS0PiOwsmobzGVXLC1DYXVD8=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.43/AdGuardHome_darwin_arm64.zip";
};
i686-linux = fetchurl {
  sha256 = "sha256-aQNvatBAVu7X/ZxhGNnqLTHMCEmzumqbxxERu4G70cc=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.43/AdGuardHome_linux_386.tar.gz";
};
x86_64-linux = fetchurl {
  sha256 = "sha256-Ck4+7HTKVuLykwVEX1rAWWJE+6bT/oIWQ1LTB7Qkls8=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.43/AdGuardHome_linux_amd64.tar.gz";
};
aarch64-linux = fetchurl {
  sha256 = "sha256-wDOYVhjF7uNFRwK7fxjdaX/J6xPX9oiz5GjyBKhjDhA=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.43/AdGuardHome_linux_arm64.tar.gz";
};
armv6l-linux = fetchurl {
  sha256 = "sha256-mThdHOvZoSXO3OXxmcfCCAUYzdYV5FPPWEXQhLUqs0A=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.43/AdGuardHome_linux_armv6.tar.gz";
};
armv7l-linux = fetchurl {
  sha256 = "sha256-oz7Akv4zv801QOqSqkIzsaMJ28BC/mgpH/VLWYj+pkk=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.43/AdGuardHome_linux_armv7.tar.gz";
};
}
