{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-solved";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-solved";
    rev = "f3b7fbb914cb0b7714d0ad7f26f21aaf1ba14f73";
    sha256 = "sha256-T7RHSk0ZP72E1hBoLwNLXX6rVOdy4JWQfj3aehbX1RM=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-solved";
    maintainers = with maintainers; [ talyz ];
    license = licenses.mit;
    description = "Allow accepted answers on topics";
  };
}
