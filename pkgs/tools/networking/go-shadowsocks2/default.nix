{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "go-shadowsocks2";
  version = "0.0.11";

  goPackagePath = "github.com/shadowsocks/go-shadowsocks2";

  src = fetchFromGitHub {
    owner = "shadowsocks";
    repo = "go-shadowsocks2";
    rev = "v${version}";
    sha256 = "1dprz84gmcp6xcsk873lhj32wm8b55vnqn0s984ggvwf1rjqw00c";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "Fresh implementation of Shadowsocks in Go";
    homepage = "https://github.com/shadowsocks/go-shadowsocks2/";
    license = licenses.asl20;
    maintainers = with maintainers; [ geistesk ];
  };
}
