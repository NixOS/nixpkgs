import ./generic.nix {
  version = "17.6";
  rev = "refs/tags/REL_17_6";
  hash = "sha256-/7C+bjmiJ0/CvoAc8vzTC50vP7OsrM6o0w+lmmHvKvU=";
  muslPatches = {
    dont-use-locale-a = {
      url = "https://git.alpinelinux.org/aports/plain/main/postgresql17/dont-use-locale-a-on-musl.patch?id=d69ead2c87230118ae7f72cef7d761e761e1f37e";
      hash = "sha256-6zjz3OpMx4qTETdezwZxSJPPdOvhCNu9nXvAaU9SwH8=";
    };
  };
}
