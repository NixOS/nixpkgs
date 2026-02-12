import ./generic.nix {
  version = "17.8";
  rev = "refs/tags/REL_17_8";
  hash = "sha256-4lV1/xRmMsc5rgY3RB6WMigTXHgHjh9bmR6nzL82Rs4=";
  muslPatches = {
    dont-use-locale-a = {
      url = "https://git.alpinelinux.org/aports/plain/main/postgresql17/dont-use-locale-a-on-musl.patch?id=d69ead2c87230118ae7f72cef7d761e761e1f37e";
      hash = "sha256-6zjz3OpMx4qTETdezwZxSJPPdOvhCNu9nXvAaU9SwH8=";
    };
  };
}
