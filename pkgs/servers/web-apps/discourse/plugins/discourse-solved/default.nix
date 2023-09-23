{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-solved";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-solved";
    rev = "b5d487d6a5bfe2571d936eec5911d02a5f3fcc32";
    sha256 = "sha256-Tt7B9PcsV8E7B+m8GnJw+MBz9rGYtojKt6NjBFMQvOM=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-solved";
    maintainers = with maintainers; [ talyz ];
    license = licenses.mit;
    description = "Allow accepted answers on topics";
  };
}
