{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  version = "0.6.0";
  pname = "grobi";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "fd0";
    repo = "grobi";
    sha256 = "032lvnl2qq9258y6q1p60lfi7qir68zgq8zyh4khszd3wdih7y3s";
  };

  vendorSha256 = "1ibwx5rbxkygfx78j3g364dmbwwa5b34qmzq3sqcbrsnv8rzrwvj";

  meta = with stdenv.lib; {
    homepage = "https://github.com/fd0/grobi";
    description = "Automatically configure monitors/outputs for Xorg via RANDR";
    license = with licenses; [ bsd2 ];
    platforms   = platforms.linux;
  };
}
