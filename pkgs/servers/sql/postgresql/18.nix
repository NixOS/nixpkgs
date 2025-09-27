import ./generic.nix {
  version = "18.0";
  rev = "refs/tags/REL_18_0";
  hash = "sha256-xA6gbJe4tIV9bYRFrdI4Rfy20ZwTkvyyjt7ZxvCFEec=";
  muslPatches = {
    dont-use-locale-a = {
      url = "https://git.alpinelinux.org/aports/plain/main/postgresql17/dont-use-locale-a-on-musl.patch?id=d69ead2c87230118ae7f72cef7d761e761e1f37e";
      hash = "sha256-6zjz3OpMx4qTETdezwZxSJPPdOvhCNu9nXvAaU9SwH8=";
    };
  };
}
