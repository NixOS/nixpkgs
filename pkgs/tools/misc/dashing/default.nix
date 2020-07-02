{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "dashing";
  version = "0.4.0";

  goPackagePath = "github.com/technosophos/dashing";

  src = fetchFromGitHub {
    owner = "technosophos";
    repo = pname;
    rev = version;
    sha256 = "0mhv0w5q5vpynbfi21n5i3yw2165bppdlg0amvbv86n9z4c21h89";
  };

  goDeps = ./deps.nix;

  buildFlagsArray = [ "-ldflags=-X main.version=${version}" ];

  meta = with stdenv.lib; {
    description = "A Dash Generator Script for Any HTML";
    homepage    = "https://github.com/technosophos/dashing";
    license     = licenses.mit;
    maintainers = [ ];
    platforms   = platforms.all;
  };
}
