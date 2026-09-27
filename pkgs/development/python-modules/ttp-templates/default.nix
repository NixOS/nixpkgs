{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pydantic,
}:

buildPythonPackage (finalAttrs: {
  pname = "ttp-templates";
  version = "0.6.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dmulyalin";
    repo = "ttp_templates";
    tag = finalAttrs.version;
    hash = "sha256-j//8gAzBXyQkSmmnJZofi2Q/lYklT/QjiU8k0a3ENDg=";
  };

  build-system = [ poetry-core ];

  dependencies = [ pydantic ];

  postPatch = ''
    # Drop circular dependency on ttp
    sed -i '/ttp =/d' pyproject.toml
  '';

  # Circular dependency on ttp
  doCheck = false;

  meta = {
    description = "Template Text Parser Templates collections";
    homepage = "https://github.com/dmulyalin/ttp_templates";
    changelog = "https://github.com/dmulyalin/ttp_templates/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
