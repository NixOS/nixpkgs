{ fetchurl, fetchzip }:
{
x86_64-darwin = fetchzip {
  sha256 = "sha256-ZhezLVn4PHPAnKCjlR9zI4zt9eJZYIUUODjS01M7q1E=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.23/AdGuardHome_darwin_amd64.zip";
};
aarch64-darwin = fetchzip {
  sha256 = "sha256-Vfu/mCR1rMBtYMsm/l5cfIwBnNNeJ7G0pC42rLdqWOk=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.23/AdGuardHome_darwin_arm64.zip";
};
i686-linux = fetchurl {
  sha256 = "sha256-1pgGKUE9hHFGPNAOYNEM0VTYBDdmcrXyJjcT9ymyyiM=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.23/AdGuardHome_linux_386.tar.gz";
};
x86_64-linux = fetchurl {
  sha256 = "sha256-ApCBjbhfoGYm0rmjQ8U1zA/VHNJgC1kBlk5DvmQ6wTc=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.23/AdGuardHome_linux_amd64.tar.gz";
};
aarch64-linux = fetchurl {
  sha256 = "sha256-qC7BrBhI9berbuIVIQ6yOo74eHRsoneVRJMx1K/Ljds=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.23/AdGuardHome_linux_arm64.tar.gz";
};
}
