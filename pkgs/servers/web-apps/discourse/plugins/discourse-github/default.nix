{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-github";
  bundlerEnvArgs.gemdir = ./.;
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-github";
    rev = "36cbacdd32916435391b4700c024074da3bcbe74";
    sha256 = "sha256-R4Kp7NFMIXYDcAZlOUdhNdN/mmQMgXlLFolzo2OZahw=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-github";
    maintainers = with maintainers; [ talyz ];
    license = licenses.mit;
    description = "Adds GitHub badges and linkback functionality";
  };

}
