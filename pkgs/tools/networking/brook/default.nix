{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "brook";
  version = "20200102";

  goPackagePath = "github.com/txthinking/brook";

  src = fetchFromGitHub {
    owner = "txthinking";
    repo = pname;
    rev = "v${version}";
    sha256 = "17h74p4apghljiyqjxgk6c4hqnyqs4lsn15gbysx26r4cvzglpx6";
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

