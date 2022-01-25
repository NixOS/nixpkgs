{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-solved";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-solved";
    rev = "d7c8c95f2dbc7fa94b09d2590d70558346f6e81e";
    sha256 = "sha256-utuv7JL/WJU48TE0+RIRoUpIFrcUpQGvPzfIXA2ZCL8=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-solved";
    maintainers = with maintainers; [ talyz ];
    license = licenses.mit;
    description = "Allow accepted answers on topics";
  };
}
