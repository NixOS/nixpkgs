{
  version = "19rc2";
  rev = "dffcca2e3c81178c64d4c1f44543a3507d0b7508";
  hash = "sha256-udWcl8t/OTBVfhpb10+qBQhB5MNbCrnFQtPMbYuV008=";
  muslPatches = {
    dont-use-locale-a = {
      url = "https://git.alpinelinux.org/aports/plain/main/postgresql17/dont-use-locale-a-on-musl.patch?id=d69ead2c87230118ae7f72cef7d761e761e1f37e";
      hash = "sha256-6zjz3OpMx4qTETdezwZxSJPPdOvhCNu9nXvAaU9SwH8=";
    };
  };
}
