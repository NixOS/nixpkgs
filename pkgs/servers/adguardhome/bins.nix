{ fetchurl, fetchzip }:
{
x86_64-darwin = fetchzip {
  sha256 = "sha256-QS/GMUXZ3FlBDfgLXEUeqWb4jNDXaRpRlieWjxmMe5U=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.11/AdGuardHome_darwin_amd64.zip";
};
aarch64-darwin = fetchzip {
  sha256 = "sha256-LQcIlQUbL7fDQQKKEr5HdL87O/dv7sD4ESqAxfeMo28=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.11/AdGuardHome_darwin_arm64.zip";
};
i686-linux = fetchurl {
  sha256 = "sha256-VIvQ+dhPi+gCGoCwwmnNscFPqfTCNqZdZsMYFYSFCuE=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.11/AdGuardHome_linux_386.tar.gz";
};
x86_64-linux = fetchurl {
  sha256 = "sha256-aTZ/nfzJBJX7pV/xn/7QwPvK95GY5DIzeNs4O/6UBDw=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.11/AdGuardHome_linux_amd64.tar.gz";
};
aarch64-linux = fetchurl {
  sha256 = "sha256-aYPMMjI7azFtGUvPy2KnS0o7lTmtsOaOVgIFCWkfNi4=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.11/AdGuardHome_linux_arm64.tar.gz";
};
}
