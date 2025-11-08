{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:

buildFishPlugin rec {
  pname = "async-prompt";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "acomagu";
    repo = "fish-async-prompt";
    rev = "v${version}";
    hash = "sha256-B7Ze0a5Zp+5JVsQUOv97mKHh5wiv3ejsDhJMrK7YOx4=";
  };

  meta = with lib; {
    description = "Make your prompt asynchronous to improve the reactivity";
    homepage = "https://github.com/acomagu/fish-async-prompt";
    license = licenses.mit;
    maintainers = [ ];
  };
}
