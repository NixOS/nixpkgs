{ lib, python3, fetchFromGitHub, plugins ? [ ] }:

python3.pkgs.buildPythonApplication rec {
  pname = "instawow";
  version = "4.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "layday";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-RRBuFja5vejzjrtOvRBIjT7sq/Wg/39FA/o9O8c2B0o=";
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
