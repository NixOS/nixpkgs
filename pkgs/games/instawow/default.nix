{ lib, python3, fetchFromGitHub, plugins ? [ ] }:

python3.pkgs.buildPythonApplication rec {
  pname = "instawow";
  version = "4.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "layday";
    repo = pname;
    tag = "v${version}";
    sha256 = "sha256-eOILlbLt7R7EvPgFYnN6Bvj0yOx3KaXTHugspa4/kBc=";
  };

  extras = [ ];  # Disable GUI, most dependencies are not packaged.

  nativeBuildInputs = with python3.pkgs; [
    hatchling
    hatch-vcs
  ];
  propagatedBuildInputs = with python3.pkgs; [
    aiohttp
    aiohttp-client-cache
    attrs
    cattrs
    click
    diskcache
    iso8601
    loguru
    packaging
    pluggy
    prompt-toolkit
    rapidfuzz
    truststore
    typing-extensions
    yarl
  ] ++ plugins;

  meta = with lib; {
    homepage = "https://github.com/layday/instawow";
    description = "World of Warcraft add-on manager CLI and GUI";
    mainProgram = "instawow";
    license = licenses.gpl3;
    maintainers = with maintainers; [ seirl ];
  };
}
