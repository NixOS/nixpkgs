{ fetchurl, fetchzip }:
{
x86_64-darwin = fetchzip {
  sha256 = "sha256-+sPPhXO0fnHQfB7fqqQsZIUW+2bzAqjE6yMzd5tLRhI=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.52/AdGuardHome_darwin_amd64.zip";
};
aarch64-darwin = fetchzip {
  sha256 = "sha256-TebackOYGFA9Q99awS5RtIuj94ys3Jzg/EbCH8cmjTU=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.52/AdGuardHome_darwin_arm64.zip";
};
i686-linux = fetchurl {
  sha256 = "sha256-26iQrdenWI+88N6iy2zOXQ/+cTuQjCVtjjhzXmUotpk=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.52/AdGuardHome_linux_386.tar.gz";
};
x86_64-linux = fetchurl {
  sha256 = "sha256-omRezyPMrbsNl7Mkrvm8Z9EmuOOUQorlojwvG3PF0UA=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.52/AdGuardHome_linux_amd64.tar.gz";
};
aarch64-linux = fetchurl {
  sha256 = "sha256-hq56fC25wVi52581BWhIXjzMQ+cDliTRpbxQux3uEEg=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.52/AdGuardHome_linux_arm64.tar.gz";
};
armv6l-linux = fetchurl {
  sha256 = "sha256-tMeNdlkqnzjzKX046GoaSjQgLD4nq82JlSH1PmSgmNM=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.52/AdGuardHome_linux_armv6.tar.gz";
};
armv7l-linux = fetchurl {
  sha256 = "sha256-fLa5H/wHo/sGjqk44JjFURvPwROC+h7nvA43/aeDiLs=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.52/AdGuardHome_linux_armv7.tar.gz";
};
}
