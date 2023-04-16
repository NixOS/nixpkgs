{ fetchurl, fetchzip }:
{
x86_64-darwin = fetchzip {
  sha256 = "sha256-amKwWr+0Q9Ci0CxLEjtxTiu/T9wJL77DPL/QiWqsMoc=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.28/AdGuardHome_darwin_amd64.zip";
};
aarch64-darwin = fetchzip {
  sha256 = "sha256-dJHFGTIv+inVU6djuQkFcOF2nTALd+1dS888ooHXt/w=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.28/AdGuardHome_darwin_arm64.zip";
};
i686-linux = fetchurl {
  sha256 = "sha256-ijcR3z0aUN0euC9oygULlMtaNnffelv45ku4zmcZkUA=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.28/AdGuardHome_linux_386.tar.gz";
};
x86_64-linux = fetchurl {
  sha256 = "sha256-aXmDer5/bq0L6SoPhqyJ8IY2FzH+TYNHDvQTZgrrrj0=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.28/AdGuardHome_linux_amd64.tar.gz";
};
aarch64-linux = fetchurl {
  sha256 = "sha256-E2QBwA0prJ4B8a6tEj9lBkAnrYUTlsweOJBpQsLBo9M=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.28/AdGuardHome_linux_arm64.tar.gz";
};
armv6l-linux = fetchurl {
  sha256 = "sha256-NARiVRdT7U0E6BUlehJbEeHQ9tF6vmCh/d59osVy/S0=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.28/AdGuardHome_linux_armv6.tar.gz";
};
armv7l-linux = fetchurl {
  sha256 = "sha256-HU6uUSfdr3UkPX+oyjGlMHJkcfpGBRphBNLtBG3oLzY=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.28/AdGuardHome_linux_armv7.tar.gz";
};
}
