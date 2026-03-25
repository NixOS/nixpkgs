{
  lib,
  mkDiscoursePlugin,
  fetchFromGitHub,
}:

mkDiscoursePlugin {
  name = "discourse-yearly-review";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-yearly-review";
    rev = "7e7df7878212ad976031cbbc17a0dd4ca1d55def";
    sha256 = "sha256-+6CmXgXEyQb6CNSqaVqbfXQCc+XJQGDQnw9vgAlse0g=";
  };
  meta = {
    homepage = "https://github.com/discourse/discourse-yearly-review";
    maintainers = with lib.maintainers; [ talyz ];
    license = lib.licenses.mit;
    description = "Publishes an automated Year in Review topic";
  };
}
