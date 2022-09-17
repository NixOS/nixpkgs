{ fetchurl, fetchzip }:
{
x86_64-darwin = fetchzip {
  sha256 = "sha256-2QGXyXHU2p7DFKDWyau2+SCzaQnM+o0EbYqHFnErXX4=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.12/AdGuardHome_darwin_amd64.zip";
};
aarch64-darwin = fetchzip {
  sha256 = "sha256-16XJUh78B45d1uuLi1xcFeti6CvGUkXYUVe4pS/hhXs=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.12/AdGuardHome_darwin_arm64.zip";
};
i686-linux = fetchurl {
  sha256 = "sha256-ML9WSJwQTC8F07MOTQBpZXH/tHSlbQEzAofGpjHZrLU=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.12/AdGuardHome_linux_386.tar.gz";
};
x86_64-linux = fetchurl {
  sha256 = "sha256-fGSBfQzlYQbsZExOqsxa2Zdb/gvo0c9O313ziSkvOjY=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.12/AdGuardHome_linux_amd64.tar.gz";
};
aarch64-linux = fetchurl {
  sha256 = "sha256-WR8omfW5udMmXNKuUIfqdXvggumG4Pb1gESJV9YZ9rc=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.12/AdGuardHome_linux_arm64.tar.gz";
};
}
