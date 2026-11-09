{
  version = "19rc1";
  rev = "refs/tags/REL_19_RC1";
  hash = "sha256-MAe7E++6Wt9N9XDJ+4ALqJ7lJLQXbDvS7ygd//b7q7Q=";
  muslPatches = {
    dont-use-locale-a = {
      url = "https://git.alpinelinux.org/aports/plain/main/postgresql17/dont-use-locale-a-on-musl.patch?id=d69ead2c87230118ae7f72cef7d761e761e1f37e";
      hash = "sha256-6zjz3OpMx4qTETdezwZxSJPPdOvhCNu9nXvAaU9SwH8=";
    };
  };
}
