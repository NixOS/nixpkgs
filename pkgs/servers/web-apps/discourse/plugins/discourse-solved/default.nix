{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-solved";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-solved";
    rev = "3b9ecc69c6a25b7671c42842b8a6f3872873f537";
    sha256 = "sha256-gtG+v25jJ0DiYlU2vatreGj13yrb5WWRTvxlcDdAibw=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-solved";
    maintainers = with maintainers; [ talyz ];
    license = licenses.mit;
    description = "Allow accepted answers on topics";
  };
}
