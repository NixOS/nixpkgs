{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-solved";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-solved";
    rev = "9aba2bd6b7efbea3e46158fd0b1ce96a975379d7";
    sha256 = "sha256-RmYsDCDuVxXX91haljP6Jbx3s4Nl2RV6UU3PBQ/Xi7Y=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-solved";
    maintainers = with maintainers; [ talyz ];
    license = licenses.mit;
    description = "Allow accepted answers on topics";
  };
}
