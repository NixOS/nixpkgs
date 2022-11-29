{ fetchurl, fetchzip }:
{
x86_64-darwin = fetchzip {
  sha256 = "sha256-R9Ggjl9Qw1F2n2U7uGcLqgjwrLoUjlO8KUsI4sQf/JU=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.19/AdGuardHome_darwin_amd64.zip";
};
aarch64-darwin = fetchzip {
  sha256 = "sha256-MStBeDsqHK+m91DBTIAzaleIL0GNhqdslIvPOmtOaDQ=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.19/AdGuardHome_darwin_arm64.zip";
};
i686-linux = fetchurl {
  sha256 = "sha256-bkUSxifnSfDZk2kmp23n6KBlqa70CrBIKuCF+EEHTwk=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.19/AdGuardHome_linux_386.tar.gz";
};
x86_64-linux = fetchurl {
  sha256 = "sha256-dHj91ZYhHTA8XoZ8oUhDQzu6Fpg0n/CBqDZux0QnwXI=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.19/AdGuardHome_linux_amd64.tar.gz";
};
aarch64-linux = fetchurl {
  sha256 = "sha256-f5nXnLkL6yvkE9kUnHdsD+MQhUjbkQGmVj7Nr/znBrw=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.19/AdGuardHome_linux_arm64.tar.gz";
};
}
