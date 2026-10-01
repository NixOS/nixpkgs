{
  version = "19beta4";
  rev = "refs/tags/REL_19_BETA4";
  hash = "sha256-D9Oxe7I9JyAaByRY/z8jYlIlydykJF2YvUZ2ScSD9i4=";
  muslPatches = {
    dont-use-locale-a = {
      url = "https://git.alpinelinux.org/aports/plain/main/postgresql17/dont-use-locale-a-on-musl.patch?id=d69ead2c87230118ae7f72cef7d761e761e1f37e";
      hash = "sha256-6zjz3OpMx4qTETdezwZxSJPPdOvhCNu9nXvAaU9SwH8=";
    };
  };
}
