{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:

buildFishPlugin {
  pname = "fish-colored-man";
  version = "0-unstable-2021-07-16";

  src = fetchFromGitHub {
    owner = "decors";
    repo = "fish-colored-man";
    rev = "1ad8fff696d48c8bf173aa98f9dff39d7916de0e";
    hash = "sha256-uoZ4eSFbZlsRfISIkJQp24qPUNqxeD0JbRb/gVdRYlA=";
  };

  meta = {
    description = "Fish shell plugin that brings colors to man pages";
    homepage = "https://github.com/decors/fish-colored-man";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dasj19 ];
  };
}
