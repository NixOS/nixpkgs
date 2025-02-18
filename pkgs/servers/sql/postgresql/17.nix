import ./generic.nix {
  version = "17.2";
  rev = "ref/tags/REL_17_2";
  hash = "sha256-P7IwvMcOI6vW14PiB2R0NEzAEPeaKg0zaUKTw2GJ5DA=";
  muslPatches = {
    dont-use-locale-a = {
      url = "https://git.alpinelinux.org/aports/plain/main/postgresql17/dont-use-locale-a-on-musl.patch?id=d69ead2c87230118ae7f72cef7d761e761e1f37e";
      hash = "sha256-6zjz3OpMx4qTETdezwZxSJPPdOvhCNu9nXvAaU9SwH8=";
    };
  };
}
