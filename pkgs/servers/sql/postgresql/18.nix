import ./generic.nix {
  version = "18.3";
  rev = "refs/tags/REL_18_3";
  hash = "sha256-3cu3oyPJ5q6ewv7RFY7Nys5l+10dsQv5f1HNIoYtrO8=";
  muslPatches = {
    dont-use-locale-a = {
      url = "https://git.alpinelinux.org/aports/plain/main/postgresql17/dont-use-locale-a-on-musl.patch?id=d69ead2c87230118ae7f72cef7d761e761e1f37e";
      hash = "sha256-6zjz3OpMx4qTETdezwZxSJPPdOvhCNu9nXvAaU9SwH8=";
    };
  };
}
