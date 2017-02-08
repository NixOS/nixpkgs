{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "wuzz-${version}";
  version = "2017-02-05";

  goPackagePath = "https://github.com/asciimoo/wuzz";

  src = fetchFromGitHub {
    owner = "asciimoo";
    repo = "wuzz";
    rev = "45b6a64e667b3647216af68e06e253958b81b3c4";
    sha256 = "0jjdyqh1jvfg1dg5fwwavcvkn8fkm1a44gyv35c1g5cd9gxwj8nw";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    homepage = https://github.com/asciimoo/wuzz;
    description = "Interactive cli tool for HTTP inspection";
    license = licenses.agpl3;
    maintainers = with maintainers; [ pradeepchhetri ];
  };
}
