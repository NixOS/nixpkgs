import ./generic.nix {
  version = "17.5";
  rev = "refs/tags/REL_17_5";
  hash = "sha256-jWV7hglu7IPMZbqHrZVZHLbZYjVuDeut7nH50aSQIBc=";
  muslPatches = {
    dont-use-locale-a = {
      url = "https://git.alpinelinux.org/aports/plain/main/postgresql17/dont-use-locale-a-on-musl.patch?id=d69ead2c87230118ae7f72cef7d761e761e1f37e";
      hash = "sha256-6zjz3OpMx4qTETdezwZxSJPPdOvhCNu9nXvAaU9SwH8=";
    };
  };
}
