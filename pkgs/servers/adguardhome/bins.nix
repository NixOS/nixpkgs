{ fetchurl, fetchzip }:
{
x86_64-darwin = fetchzip {
  sha256 = "sha256-ygf5D8s1Yv9J1mVDAZrW9Q/4scQopQ547TfHG+fFwoU=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.29/AdGuardHome_darwin_amd64.zip";
};
aarch64-darwin = fetchzip {
  sha256 = "sha256-s112LwCusgRcTaGmKWcRlUA2XnbdxJ7lVkWzG3QIUqQ=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.29/AdGuardHome_darwin_arm64.zip";
};
i686-linux = fetchurl {
  sha256 = "sha256-mBqxPT/qaER4nI1+pmmpUSTJuCb9eax9DMRIY+J92Lk=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.29/AdGuardHome_linux_386.tar.gz";
};
x86_64-linux = fetchurl {
  sha256 = "sha256-M4VfjRnrqYxKc9neIJndJoa8D44RRIjN5ItE4Ec6VKY=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.29/AdGuardHome_linux_amd64.tar.gz";
};
aarch64-linux = fetchurl {
  sha256 = "sha256-6zekpNnfss4r/Z+g/Te0O+oDpCskKu39NI8Q0e7bHOo=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.29/AdGuardHome_linux_arm64.tar.gz";
};
armv6l-linux = fetchurl {
  sha256 = "sha256-j0n3lKyaxOXX7YHcpYlC1dpCz741q1tes2kgadHzivI=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.29/AdGuardHome_linux_armv6.tar.gz";
};
armv7l-linux = fetchurl {
  sha256 = "sha256-LyD3arGmk5YWXB2FZBLPcMAukvBtlXfFPSQ/mZBJohA=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.29/AdGuardHome_linux_armv7.tar.gz";
};
}
