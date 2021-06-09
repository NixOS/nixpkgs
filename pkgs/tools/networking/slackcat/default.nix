{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "slackcat";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "bcicen";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "1ha9b2dffpxqs159ldqdh1aibn3316xab19vdn2yjgk8r508wm31";
  };

  goPackagePath = "github.com/bcicen/slackcat";

  meta = with stdenv.lib; {
    description = "CLI utility to post files and command output to slack";
    homepage = "http://slackcat.chat/";
    license = licenses.mit;
    maintainers = with maintainers; [ nasadorian ];
  };
}
