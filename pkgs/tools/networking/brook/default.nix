{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "brook";
  version = "20190401";

  goPackagePath = "github.com/txthinking/brook";

  src = fetchFromGitHub {
    owner = "txthinking";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "0kx0dpvr3llpdzmw5bvzhdvwkmzrv6kqbsilx6rgrvyl61y9pyry";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    homepage = https://github.com/txthinking/brook;
    description = "A cross-platform Proxy/VPN software";
    license = with licenses; [ gpl3 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ xrelkd ];
  };
}

