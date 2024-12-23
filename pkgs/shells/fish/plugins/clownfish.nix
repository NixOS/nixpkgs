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
    sha256 = "04xvikyrdm6yxh588vbpwvm04fas76pa7sigsaqrip7yh021xxab";
  };

  meta = with lib; {
    description = "Fish function to mock the behaviour of commands";
    homepage = "https://github.com/IlanCosman/clownfish";
    license = licenses.mit;
    maintainers = with maintainers; [ pacien ];
  };
}
