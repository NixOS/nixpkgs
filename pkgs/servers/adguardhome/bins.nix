{ fetchurl, fetchzip }:
{
x86_64-darwin = fetchzip {
  sha256 = "sha256-sfEnGeWjqCjjZSUUVMi5tsqXdrkCPXrg7Xpi8jTmjLU=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.24/AdGuardHome_darwin_amd64.zip";
};
aarch64-darwin = fetchzip {
  sha256 = "sha256-htHUgx/A+AOhlbEjK5tEvJ0GbC/GsEUz/N2x9Wfyr5o=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.24/AdGuardHome_darwin_arm64.zip";
};
i686-linux = fetchurl {
  sha256 = "sha256-VzPxraAqmTp6c9OFw3VbpcpzRVkAxiaOlA/eQT7z/js=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.24/AdGuardHome_linux_386.tar.gz";
};
x86_64-linux = fetchurl {
  sha256 = "sha256-cQMKUL5RT+CJiCwXnOPc9o0AwDmo0Z6X8L8TjWTKwpY=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.24/AdGuardHome_linux_amd64.tar.gz";
};
aarch64-linux = fetchurl {
  sha256 = "sha256-TixmsB8ZmevQB/ZK7NhtZGchDm+r8XRkCR7qiaUTKLE=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.24/AdGuardHome_linux_arm64.tar.gz";
};
armv6l-linux = fetchurl {
  sha256 = "sha256-OUvxgvF8qtLuFVuhLYEL7HipcTZrpuYxp8u7uroaUMc=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.24/AdGuardHome_linux_armv6.tar.gz";
};
armv7l-linux = fetchurl {
  sha256 = "sha256-okhx2mOIBzJevugpcUh12D85WATV7iCqiiOuvOgUezI=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.24/AdGuardHome_linux_armv7.tar.gz";
};
}
