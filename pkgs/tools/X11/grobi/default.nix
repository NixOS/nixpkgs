{ stdenv, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  version = "0.5.1";
  name = "grobi-${version}";

  goPackagePath = "github.com/fd0/grobi";

  src = fetchFromGitHub {
    rev = "5ddc167b9e4f84755a515828360abda15c54b7de";
    owner = "fd0";
    repo = "grobi";
    sha256 = "0iyxidq60pf6ki52f8fffplf10nl8w9jx1b7igg98csnc6iqxh89";
  };

   meta = with stdenv.lib; {
    homepage = https://github.com/fd0/grobi;
    description = "Automatically configure monitors/outputs for Xorg via RANDR";
    license = with licenses; [ bsd2 ];
    platforms   = platforms.linux;
  };
}
