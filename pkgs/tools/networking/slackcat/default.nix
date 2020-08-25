{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "slackcat";
  version = "1.6";
  goPackagePath = "github.com/bcicen/slackcat";
  src = fetchFromGitHub {
    owner = "bcicen";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "1ha9b2dffpxqs159ldqdh1aibn3316xab19vdn2yjgk8r508wm31";
  };
  goDeps = ./deps.nix;
  meta = with stdenv.lib; {
    description = "CLI utility to post files and command output to slack";
    homepage = "http://slackcat.chat/";
    license = licenses.mit;
    maintainers = with maintainers; [];
  };
}
