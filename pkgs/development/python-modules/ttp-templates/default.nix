{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pydantic,
}:

buildPythonPackage (finalAttrs: {
  pname = "ttp-templates";
  version = "0.5.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dmulyalin";
    repo = "ttp_templates";
    tag = finalAttrs.version;
    hash = "sha256-W6F0/CGm713HhCtgqv+tEDm5mlkx0JJRmnUc9j+Fnvs=";
  };

  nativeBuildInputs = [ poetry-core ];

  dependencies = [ pydantic ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.5.7"' 'version = "${finalAttrs.version}"'

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
