{ fetchurl, fetchzip }:
{
  x86_64-darwin = fetchzip {
    sha256 = "sha256-/6NiFNu0P3WIoJM26c6W9Bh/3+J9bkGDJmKUg1bhpkQ=";
    url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.53/AdGuardHome_darwin_amd64.zip";
  };
  aarch64-darwin = fetchzip {
    sha256 = "sha256-iOEyRAmLEe8pRGVVUHov+YguvqihYBJaCd/Tcek7ooo=";
    url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.53/AdGuardHome_darwin_arm64.zip";
  };
  i686-linux = fetchurl {
    sha256 = "sha256-ATE57Xo/4AOEtZup52PBnVDiP+tpEQMF1Z7w4lh3/uU=";
    url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.53/AdGuardHome_linux_386.tar.gz";
  };
  x86_64-linux = fetchurl {
    sha256 = "sha256-a+NhiHSTBvTkJedpTxhsl5JpuN/Mtb4+g7bhwxahMUw=";
    url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.53/AdGuardHome_linux_amd64.tar.gz";
  };
  aarch64-linux = fetchurl {
    sha256 = "sha256-7Gt0udLXllYqso70u5lH7kuF96lRnnH614B3h89phwA=";
    url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.53/AdGuardHome_linux_arm64.tar.gz";
  };
  armv6l-linux = fetchurl {
    sha256 = "sha256-6RVRG5nM0zlLLYt/a7B4mHYV93oske+G51CIeIBJ4lA=";
    url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.53/AdGuardHome_linux_armv6.tar.gz";
  };
  armv7l-linux = fetchurl {
    sha256 = "sha256-xpc83aflT+iWW2dboG1sD5xp1xd2THWd+YEggrYq90I=";
    url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.53/AdGuardHome_linux_armv7.tar.gz";
  };
}
