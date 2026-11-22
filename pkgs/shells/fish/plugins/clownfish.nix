{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:

buildFishPlugin {
  pname = "clownfish";
  version = "0-unstable-2021-01-17";

  src = fetchFromGitHub {
    owner = "IlanCosman";
    repo = "clownfish";
    rev = "a0db28d8280d05561b8f48c0465480725feeca4c";
    hash = "sha256-S/UeBID+3Jix0i/qo645WjkC6uZ3bYQK7N7Ulv2MuxM=";
  };

  meta = {
    description = "Fish function to mock the behaviour of commands";
    homepage = "https://github.com/IlanCosman/clownfish";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ euxane ];
  };
}
