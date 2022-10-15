{ fetchurl, fetchzip }:
{
x86_64-darwin = fetchzip {
  sha256 = "sha256-rVc1ad8qwXfEuqZUrTsdzSQHUit3j8PQp3B0dD6FrcQ=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.16/AdGuardHome_darwin_amd64.zip";
};
aarch64-darwin = fetchzip {
  sha256 = "sha256-GaeTdv467dVfSk2YuILmi2KphMfFYfLdpNI+dVx/UoU=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.16/AdGuardHome_darwin_arm64.zip";
};
i686-linux = fetchurl {
  sha256 = "sha256-6fXU2vU3MgveWZhgrphOeczDc1GUBv7ZUehPF8+GUdY=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.16/AdGuardHome_linux_386.tar.gz";
};
x86_64-linux = fetchurl {
  sha256 = "sha256-6rUC0R0bGS4omX9bybShk78mFaNRjUUkQqczZE2Wz5M=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.16/AdGuardHome_linux_amd64.tar.gz";
};
aarch64-linux = fetchurl {
  sha256 = "sha256-3cowMi081TIx65dgzBP+YkIj4IBwyK1Yd/gn2zL9kOI=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.16/AdGuardHome_linux_arm64.tar.gz";
};
}
