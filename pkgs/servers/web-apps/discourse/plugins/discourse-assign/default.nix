{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-assign";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-assign";
    rev = "d8d2dc950a0512cc53885afbd1da26ea38fdf1e1";
    sha256 = "sha256-FRq/zL+Hiu/Pd/8HDOmFW8Uoovw9so1gKbM4by3jSYg=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-docs";
    maintainers = with maintainers; [ dpausp ];
    license = licenses.mit;
    description = "Discourse Plugin for assigning users to a topic";
  };
}
