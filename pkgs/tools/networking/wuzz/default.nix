{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "wuzz-${version}";
  version = "0.1.0";
  rev = "v${version}";

  goPackagePath = "https://github.com/asciimoo/wuzz";

  src = fetchFromGitHub {
    owner = "asciimoo";
    repo = "wuzz";
    inherit rev;
    sha256 = "0n55y9dmx4rsccjscvbrgiq2g1qwqxj44lg90589i55b5f7r1ljd";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    homepage = https://github.com/asciimoo/wuzz;
    description = "Interactive cli tool for HTTP inspection";
    license = licenses.agpl3;
    maintainers = with maintainers; [ pradeepchhetri ];
  };
}
