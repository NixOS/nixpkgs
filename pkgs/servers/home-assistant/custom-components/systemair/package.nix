{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:

buildHomeAssistantComponent rec {
  owner = "tesharp";
  domain = "systemair";
  version = "0.2.0";

  src = fetchFromGitHub {
    inherit owner;
    repo = "systemair";
    rev = "refs/tags/v${version}";
    hash = "sha256-lzFnKPkBOt2fkVGWCj1M/skSr8V39GgDHS+0HD4ACAw=";
  };

  meta = with lib; {
    changelog = "https://github.com/tesharp/systemair/releases/tag/v${version}";
    description = "Home Assistant component for Systemair SAVE Connect 2";
    homepage = "https://github.com/tesharp/systemair";
    maintainers = with maintainers; [ uvnikita ];
    license = licenses.mit;
  };
}
