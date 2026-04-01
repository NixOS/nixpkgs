{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,

  # Python dependencies
  attrs,
  certifi,
  exceptiongroup,
  websockets,
  filelock,
  fasteners,
  mycdp,
  platformdirs,
  typing-extensions,
  sbvirtualdisplay,
  markupsafe,
  jinja2,
  parse,
  parse-type,
  colorama,
  pyyaml,
  pygments,
  idna,
  charset-normalizer,
  requests,
  sniffio,
  h11,
  outcome,
  trio,
  trio-websocket,
  wsproto,
  websocket-client,
  selenium,
  cssselect,
  nest-asyncio,
  sortedcontainers,
  execnet,
  iniconfig,
  soupsieve,
  beautifulsoup4,
  pyotp,
  xlib,
  pyautogui,
  markdown-it-py,
  mdurl,
  rich,
}:

buildPythonPackage (finalAttrs: {
  pname = "seleniumbase";
  version = "4.47.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "seleniumbase";
    repo = "SeleniumBase";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GjGSLhNYfwTikUcTxF2P3YmdoHpFuJoVhPGtrht9zG0=";
  };

  pythonRemoveDeps = [
    "pip"
    "mycdp"
    "pynose"
    "sbvirtualdisplay"
    "pdbp"
    "setuptools"
    "packaging"
    "wheel"
    "tabcompleter"
    "pluggy"
    "pytest"
    "pytest-html"
    "pytest-metadata"
    "pytest-ordering"
    "pytest-rerunfailures"
    "pytest-xdist"
    "parameterized"
    "behave"
  ];

  pythonRelaxDeps = [
    "attrs"
    "certifi"
    "filelock"
    "platformdirs"
    "parse"
    "pygments"
    "charset-normalizer"
    "requests"
    "trio"
    "selenium"
    "cssselect"
    "nest-asyncio"
    "pyautogui"
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    attrs
    certifi
    exceptiongroup
    websockets
    filelock
    fasteners
    mycdp
    platformdirs
    typing-extensions
    sbvirtualdisplay
    markupsafe
    jinja2
    parse
    parse-type
    colorama
    pyyaml
    pygments
    idna
    charset-normalizer
    requests
    sniffio
    h11
    outcome
    trio
    trio-websocket
    wsproto
    websocket-client
    selenium
    cssselect
    nest-asyncio
    sortedcontainers
    execnet
    iniconfig
    soupsieve
    beautifulsoup4
    pyotp
    xlib
    pyautogui
    markdown-it-py
    mdurl
    rich
  ];

  # Tests all require network access
  doCheck = false;

  pythonCheckImports = [
    "seleniumbase"
    "sbase"
  ];

  meta = {
    changelog = "https://github.com/seleniumbase/SeleniumBase/releases/tag/v${finalAttrs.version}";
    description = "APIs for browser automation, testing, and bypassing bot-detection";
    homepage = "https://seleniumbase.io/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      pyrox0
    ];
  };
})
