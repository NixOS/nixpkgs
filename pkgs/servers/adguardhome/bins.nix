{ fetchurl, fetchzip }:
{
x86_64-darwin = fetchzip {
  sha256 = "sha256-ViWbvpGU6mk9N8Nstn0urZrcd8JIPs9Ok9806+vUvy0=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.21/AdGuardHome_darwin_amd64.zip";
};
aarch64-darwin = fetchzip {
  sha256 = "sha256-ixfeTi2Y44Om7RCKZOw3oJX+FiwTT+s7MSSqowyNKUU=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.21/AdGuardHome_darwin_arm64.zip";
};
i686-linux = fetchurl {
  sha256 = "sha256-EZzZ8Z6N+wctI/ncLjIAvFgQN1YWOnywhihxF+C6MOs=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.21/AdGuardHome_linux_386.tar.gz";
};
x86_64-linux = fetchurl {
  sha256 = "sha256-xU5PxscqBEGNCgA241UbhJcxlNXpCxbFeU7bfmSqf7I=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.21/AdGuardHome_linux_amd64.tar.gz";
};
aarch64-linux = fetchurl {
  sha256 = "sha256-ajhvvxYwttEaCQXL4WaDcjzk8g0krhIXJv5VHEEdfqg=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.21/AdGuardHome_linux_arm64.tar.gz";
};
}
