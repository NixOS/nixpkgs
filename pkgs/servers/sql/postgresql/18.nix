import ./generic.nix {
  version = "18.7";
  rev = "f5c41f6681c910b3f69951bf6fb97c6d74605d25";
  hash = "sha256-w4i0GEdrJBn56ZSgn/BsCe3QPAj0wZjl8odggO2cTXI=";
  muslPatches = {
    dont-use-locale-a = {
      url = "https://git.alpinelinux.org/aports/plain/main/postgresql17/dont-use-locale-a-on-musl.patch?id=d69ead2c87230118ae7f72cef7d761e761e1f37e";
      hash = "sha256-6zjz3OpMx4qTETdezwZxSJPPdOvhCNu9nXvAaU9SwH8=";
    };
  };
}
