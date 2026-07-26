{
  version = "19beta2";
  rev = "refs/tags/REL_19_BETA2";
  hash = "sha256-3bfWDt6+iXJG/Wy2i8R7B+H7fMbLsSSD3qzuOXTpmtc=";
  muslPatches = {
    dont-use-locale-a = {
      url = "https://git.alpinelinux.org/aports/plain/main/postgresql17/dont-use-locale-a-on-musl.patch?id=d69ead2c87230118ae7f72cef7d761e761e1f37e";
      hash = "sha256-6zjz3OpMx4qTETdezwZxSJPPdOvhCNu9nXvAaU9SwH8=";
    };
  };
}
