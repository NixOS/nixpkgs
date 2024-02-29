import ./generic.nix {
  version = "15.6";
  hash = "sha256-hFUUbtnGnJOlfelUrq0DAsr60DXCskIXXWqh4X68svs=";
  muslPatches = {
    icu-collations-hack = {
      url = "https://git.alpinelinux.org/aports/plain/main/postgresql15/icu-collations-hack.patch?id=f424e934e6d076c4ae065ce45e734aa283eecb9c";
      hash = "sha256-HgtmhF4OJYU9macGJbTB9PjQi/yW7c3Akm3U0niWs8I=";
    };
  };
}
