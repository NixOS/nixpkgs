{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-github";
  bundlerEnvArgs.gemdir = ./.;
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-github";
    rev = "8cd8c0703991c16cb2fa8cb1fd22a9c3849c7ae2";
    sha256 = "17ga31a10sm3fqjpf40mz7fk62vynyng2a243pia9fjdq9py8slx";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-github";
    maintainers = with maintainers; [ talyz ];
    license = licenses.mit;
    description = "Adds GitHub badges and linkback functionality";
  };

}
