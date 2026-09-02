{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:
buildFishPlugin (finalAttrs: {
  pname = "fifc";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "gazorby";
    repo = "fifc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-huBcOdjiRztGyqcMX4vnrr8lLjtWBcCYvBLXr1JNNQs=";
  };

  meta = {
    description = "Fzf powers on top of fish completion engine and allows customizable completion rules";
    homepage = "https://github.com/gazorby/fifc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hmajid2301 ];
  };
})
