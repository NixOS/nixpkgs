{ fetchurl, fetchzip }:
{
x86_64-darwin = fetchzip {
  sha256 = "sha256-T5iD2Ojo+/125NeEhy911kitypLNcyJq9JPnPd/91HE=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.50/AdGuardHome_darwin_amd64.zip";
};
aarch64-darwin = fetchzip {
  sha256 = "sha256-cge+z/oAiRcbZXijm6FDP7C5L7jLoi/QCr4unYoN+jQ=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.50/AdGuardHome_darwin_arm64.zip";
};
i686-linux = fetchurl {
  sha256 = "sha256-PHUUqWL3ILlQutWqUyd9jGi80lC/PQPInFQa66sx3CI=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.50/AdGuardHome_linux_386.tar.gz";
};
x86_64-linux = fetchurl {
  sha256 = "sha256-krxAIJSQrvZrXsAfFZOr/ons4mSKnaQ+fIdHULKcvyA=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.50/AdGuardHome_linux_amd64.tar.gz";
};
aarch64-linux = fetchurl {
  sha256 = "sha256-JDGOE+tdRo6De7+zQK8hKNu7YwJKphm2/PY8jfaE8QE=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.50/AdGuardHome_linux_arm64.tar.gz";
};
armv6l-linux = fetchurl {
  sha256 = "sha256-yDtOpbfuiI0kt4XSLZvwf5Uvai2N0zpJhg6kKxyyM+8=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.50/AdGuardHome_linux_armv6.tar.gz";
};
armv7l-linux = fetchurl {
  sha256 = "sha256-UvuWyrinTozuc+SEc7twUhYbYUCUc6cG66sqmUS01nk=";
  url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.50/AdGuardHome_linux_armv7.tar.gz";
};
}
