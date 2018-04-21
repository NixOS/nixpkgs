{ stdenv, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  version = "0.3.0";
  name = "grobi-${version}";

  goPackagePath = "github.com/fd0/grobi";

  src = fetchFromGitHub {
    rev = "78a0639ffad765933a5233a1c94d2626e24277b8";
    owner = "fd0";
    repo = "grobi";
    sha256 = "16q7vnhb1p6ds561832sfdszvlafww67bjn3lc0d18v7lyak2l3i";
  };

   meta = with stdenv.lib; {
    homepage = https://github.com/fd0/grobi;
    description = "Automatically configure monitors/outputs for Xorg via RANDR";
    license = with licenses; [ bsd2 ];
    platforms   = platforms.linux;
  };
}
