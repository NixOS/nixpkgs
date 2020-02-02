{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "brook";
  version = "20200201";

  goPackagePath = "github.com/txthinking/brook";

  src = fetchFromGitHub {
    owner = "txthinking";
    repo = pname;
    rev = "v${version}";
    sha256 = "0fyw2q99gapnrg836x299sgagx94a5jpw4x3gnsf69fih7cqp9lm";
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

