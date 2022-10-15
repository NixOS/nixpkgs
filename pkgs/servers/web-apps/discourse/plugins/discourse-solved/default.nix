{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-solved";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-solved";
    rev = "e96934d60f3fb97a949e0d901fd1c061e6c3bd71";
    sha256 = "sha256-DOFUTiTYffvrwmHkEuX5TGk0VL3iqSziXZ3ogsbkwjQ=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-solved";
    maintainers = with maintainers; [ talyz ];
    license = licenses.mit;
    description = "Allow accepted answers on topics";
  };
}
