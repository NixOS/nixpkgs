{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  defusedxml,
  httpx,
  platformdirs,
  protego,
  pydantic,
  pyyaml,
  rich,
  typer,

  # optional-dependencies
  xlsxwriter,

  # tests
  openpyxl,
  pytest-asyncio,
  pytestCheckHook,
  respx,
}:

buildPythonPackage (finalAttrs: {
  pname = "shopify-spy";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ndgigliotti";
    repo = "shopify-spy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ruxZCCIF88VsLtZbNvdymIDfVk+NpFop+Xylm4xJTow=";
  };

  build-system = [ hatchling ];

  dependencies = [
    defusedxml
    httpx
    platformdirs
    protego
    pydantic
    pyyaml
    rich
    typer
  ];

  optional-dependencies = {
    excel = [ xlsxwriter ];
  };

  nativeCheckInputs = [
    openpyxl
    pytest-asyncio
    pytestCheckHook
    respx
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  # The CLI writes its log under the platformdirs state directory
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTestMarks = [
    # Calls real stores
    "integration"
    # Runs the CLI against local servers with tight timeouts
    "e2e"
  ];

  pythonImportsCheck = [ "shopify_spy" ];

  meta = {
    description = "Python library and CLI to scrape product data, images, and collections from Shopify and WooCommerce stores";
    homepage = "https://github.com/ndgigliotti/shopify-spy";
    changelog = "https://github.com/ndgigliotti/shopify-spy/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ndgigliotti ];
    mainProgram = "shopify-spy";
  };
})
