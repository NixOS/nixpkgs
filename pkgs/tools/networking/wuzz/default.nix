{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "wuzz-${version}";
  version = "2017-02-09";

  goPackagePath = "https://github.com/asciimoo/wuzz";

  src = fetchFromGitHub {
    owner = "asciimoo";
    repo = "wuzz";
    rev = "dd696dc6e014e08b6042a71dca600356eb3156c2";
    sha256 = "0m7jcb6rk0cb3giz1cbfhy3h4nzjl6qrk2k6czhn9267688rznpx";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    homepage = https://github.com/asciimoo/wuzz;
    description = "Interactive cli tool for HTTP inspection";
    license = licenses.agpl3;
    maintainers = with maintainers; [ pradeepchhetri ];
  };
}
