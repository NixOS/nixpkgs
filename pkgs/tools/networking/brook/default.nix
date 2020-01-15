{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "brook";
  version = "20190601";

  goPackagePath = "github.com/txthinking/brook";

  src = fetchFromGitHub {
    owner = "txthinking";
    repo = pname;
    rev = "v${version}";
    sha256 = "04gx1p447wabw3d18s9sm8ynlvj2bp8ac9dsgs08kd1dyrsjlljk";
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

