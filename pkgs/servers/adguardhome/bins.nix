{ fetchurl, fetchzip }:
{
x86_64-darwin = fetchzip {
  sha256 = "sha256-SLGzciTzzvW0DTG8v6lNb1IovbOjxBFgFVjNY6MEyKY=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.9/AdGuardHome_darwin_amd64.zip";
};
aarch64-darwin = fetchzip {
  sha256 = "sha256-d7hnCM7BJuYfSH89jv516uVyKTMueQmVKQxEeTGIDUE=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.9/AdGuardHome_darwin_arm64.zip";
};
i686-linux = fetchurl {
  sha256 = "sha256-wTmUF6NHWis4dyw/bPjAjvZ0aQ1l1BCDlm6eLu4m/0o=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.9/AdGuardHome_linux_386.tar.gz";
};
x86_64-linux = fetchurl {
  sha256 = "sha256-Mxe9Gb1ErrZZl3a+0SqC/0ghoeV51X93YxIOs9gM2lY=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.9/AdGuardHome_linux_amd64.tar.gz";
};
aarch64-linux = fetchurl {
  sha256 = "sha256-SyHuzXAe24Nf0v9Ds3Z+cbXoIVLCJSj243I6B0XWBlM=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.9/AdGuardHome_linux_arm64.tar.gz";
};
}
