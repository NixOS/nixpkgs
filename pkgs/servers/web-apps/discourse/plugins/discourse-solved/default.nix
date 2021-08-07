{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-solved";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-solved";
    rev = "b96374bf4ab7e6d5cecb0761918b060a524eb9bf";
    sha256 = "0zrv70p0wz93akpcj6gpwjkw7az3iz9bx4n2z630kyrlmxdbj32a";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-solved";
    maintainers = with maintainers; [ talyz ];
    license = licenses.mit;
    description = "Allow accepted answers on topics";
  };
}
