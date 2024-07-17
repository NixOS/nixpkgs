{ fetchurl, fetchzip }:
{
  x86_64-darwin = fetchzip {
    sha256 = "sha256-97o4rMNwikQZR3DPhhE+OPlY3gA9HqCQxBf+mZSfDMs=";
    url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.48/AdGuardHome_darwin_amd64.zip";
  };
  aarch64-darwin = fetchzip {
    sha256 = "sha256-ZTGqn6xM9vRHmw2ask5P4vu+5BqkWfGS3ROzTN9VfXM=";
    url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.48/AdGuardHome_darwin_arm64.zip";
  };
  i686-linux = fetchurl {
    sha256 = "sha256-EbRiiThZsmBD/grtm58Su78OeF/6buwMbx6eBsusgII=";
    url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.48/AdGuardHome_linux_386.tar.gz";
  };
  x86_64-linux = fetchurl {
    sha256 = "sha256-FUnQJ3RRtsWz4DIO8Zi9Y6dO130qTdwj6RhJ6RNpljc=";
    url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.48/AdGuardHome_linux_amd64.tar.gz";
  };
  aarch64-linux = fetchurl {
    sha256 = "sha256-OZDryRiwyM6XgoiOhCsM6AFOE9masnGu2m6sDRUAaeY=";
    url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.48/AdGuardHome_linux_arm64.tar.gz";
  };
  armv6l-linux = fetchurl {
    sha256 = "sha256-aL/wKQ9lbPgaTGCjZAph5iggSTJB1+Rrxbpf6IVgjuU=";
    url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.48/AdGuardHome_linux_armv6.tar.gz";
  };
  armv7l-linux = fetchurl {
    sha256 = "sha256-siWf7frIciYGVP7KgqS4Dr7o52y3QqGYvQlxtw2HnEo=";
    url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.48/AdGuardHome_linux_armv7.tar.gz";
  };
}
