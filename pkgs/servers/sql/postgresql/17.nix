import ./generic.nix {
  version = "17.12";
  rev = "702b3dc86d35bcc08c8e23cffa3c4d9fe9d32c85";
  hash = "sha256-+DD+nYTFHwyDW3CIMoeTnCfyxQBXl9gvHlUmo4eOFjo=";
  muslPatches = {
    dont-use-locale-a = {
      url = "https://git.alpinelinux.org/aports/plain/main/postgresql17/dont-use-locale-a-on-musl.patch?id=d69ead2c87230118ae7f72cef7d761e761e1f37e";
      hash = "sha256-6zjz3OpMx4qTETdezwZxSJPPdOvhCNu9nXvAaU9SwH8=";
    };
  };
}
