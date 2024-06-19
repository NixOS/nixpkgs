{ fetchurl, fetchzip }:
{
x86_64-darwin = fetchzip {
  sha256 = "sha256-4/NrNKzpAV9vdpKCngY8f2XCEFE3rTmfQkaubFNcdWg=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.51/AdGuardHome_darwin_amd64.zip";
};
aarch64-darwin = fetchzip {
  sha256 = "sha256-MCll8iM453MXAWJiQFSwykoSBzB4MsfSCTPFTogYsSc=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.51/AdGuardHome_darwin_arm64.zip";
};
i686-linux = fetchurl {
  sha256 = "sha256-F9hRelvPZr+2QC+oL4gT6Qo+gm/oyZdGyqNnZEJXeLc=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.51/AdGuardHome_linux_386.tar.gz";
};
x86_64-linux = fetchurl {
  sha256 = "sha256-brYcemcUwEkiB3yCh2y7n2Ii6D7GfKMKqm3FVCPZV7I=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.51/AdGuardHome_linux_amd64.tar.gz";
};
aarch64-linux = fetchurl {
  sha256 = "sha256-QCkh5zyUyf1COk2cb8sGdPtSzBYTjwpH3FSaI3jG5v0=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.51/AdGuardHome_linux_arm64.tar.gz";
};
armv6l-linux = fetchurl {
  sha256 = "sha256-7dEWH+cTrrcdO7RSHX4w95jlNH3FVtJ1cFOI6/mOBfU=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.51/AdGuardHome_linux_armv6.tar.gz";
};
armv7l-linux = fetchurl {
  sha256 = "sha256-ODpHuFU4YxDeQAOyDptFQXvLPcTDJwBp4irEk5sry5U=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.51/AdGuardHome_linux_armv7.tar.gz";
};
}
