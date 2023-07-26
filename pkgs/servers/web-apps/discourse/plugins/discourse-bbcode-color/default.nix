{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-bbcode-color";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-bbcode-color";
    rev = "f9ebbf016c8c5c763473ff36cc30fdcdf8fcf480";
    sha256 = "sha256-7iCKhMdVlFdHMXxU8mQMU1vFiAbr1qKvG29VdAki+14=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-bbcode-color";
    maintainers = with maintainers; [ ryantm ];
    license = licenses.mit;
    description = "Support BBCode color tags.";
  };
}
