{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "manul-unstable-2016-09-30";

  goPackagePath = "github.com/kovetskiy/manul";
  excludedPackages = "tests";

  src = fetchFromGitHub {
    owner = "kovetskiy";
    repo = "manul";
    rev = "7bddb5404b9ecc66fd28075bb899c2d6dc7a1c51";
    sha256 = "06kglxdgj1dfpc9bdnvhsh8z0c1pdbmwmfx4km01wpppzk06dnvm";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "The madness vendoring utility for Golang programs";
    homepage = https://github.com/kovetskiy/manul;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.mic92 ];
  };
}
