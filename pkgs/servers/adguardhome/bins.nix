{ fetchurl, fetchzip }:
{
"x86_64-darwin" = fetchzip {
  sha256 = "sha256-vUOdHDyvVg+8GhctW925WfjONi7TnPRfVfXmehOweB4=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.6/AdGuardHome_darwin_amd64.zip";
};
"i686-linux" = fetchurl {
  sha256 = "sha256-A6IsDRbRHyU0+IUKkrudKvlKiJkVNNs12MrKQ6RlpMQ=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.6/AdGuardHome_linux_386.tar.gz";
};
"x86_64-linux" = fetchurl {
  sha256 = "sha256-nPcqAk0m1e9izkylBuNcatHESgvSewR+MKmVdz+HBec=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.6/AdGuardHome_linux_amd64.tar.gz";
};
"aarch64-linux" = fetchurl {
  sha256 = "sha256-ITkZdVU03FG9AUAMgD6nlCyioPJX357wB9m1jYdPlS4=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.6/AdGuardHome_linux_arm64.tar.gz";
};
}
