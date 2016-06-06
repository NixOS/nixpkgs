{ stdenv, lib, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "oauth2_proxy-${version}";
  version = "20160120-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "10f47e325b782a60b8689653fa45360dee7fbf34";
  
  goPackagePath = "github.com/bitly/oauth2_proxy";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/bitly/oauth2_proxy";
    sha256 = "13f6kaq15f6ial9gqzrsx7i94jhd5j70js2k93qwxcw1vkh1b6si";
  };

  goDeps = ./deps.json;
}
