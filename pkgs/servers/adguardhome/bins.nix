{ fetchurl, fetchzip }:
{
x86_64-darwin = fetchzip {
  sha256 = "sha256-PYq6AKX3Ifo8vMnPYGjqHwFejOBuQjhfDG5nXnccfvE=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.8/AdGuardHome_darwin_amd64.zip";
};
aarch64-darwin = fetchzip {
  sha256 = "sha256-ep5/VMO7LmfD6+chG2SGwkc5awoeqACQeP04YpMXI1s=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.8/AdGuardHome_darwin_arm64.zip";
};
i686-linux = fetchurl {
  sha256 = "sha256-rD5UDkAMeBfnrEpxfZWgDQEUN+82D6Ul2gjclS8A8CU=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.8/AdGuardHome_linux_386.tar.gz";
};
x86_64-linux = fetchurl {
  sha256 = "sha256-buBp5WZ1jIzQDbxzVOZC/t3iv1Dw0P/PN3wGBbGaYvU=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.8/AdGuardHome_linux_amd64.tar.gz";
};
aarch64-linux = fetchurl {
  sha256 = "sha256-d6Z46L6qeXi5UNPY3/nlTJvVCuQ0lamtR49Z73O87Wc=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.8/AdGuardHome_linux_arm64.tar.gz";
};
}
