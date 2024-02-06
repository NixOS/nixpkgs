{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-bbcode-color";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-bbcode-color";
    rev = "79ed22b3a3352adbd20f7e2222b9dbdb9fbaf7fe";
    sha256 = "sha256-AHgny9BW/ssmv0U2lwzVWgYKPsvWHD6kgU3mBMFX4Aw=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-bbcode-color";
    maintainers = with maintainers; [ ryantm ];
    license = licenses.mit;
    description = "Support BBCode color tags.";
  };
}
