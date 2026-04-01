{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "ttp-templates";
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dmulyalin";
    repo = "ttp_templates";
    tag = version;
    hash = "sha256-lGlg8AgP7VtwZm5xfpEzs1VJSbfBdYns/l4ROP0LtEQ=";
  };

  nativeBuildInputs = [ poetry-core ];

  postPatch = ''
    # Drop circular dependency on ttp
    sed -i '/ttp =/d' pyproject.toml
  '';

  # Circular dependency on ttp
  doCheck = false;

  meta = {
    description = "Template Text Parser Templates collections";
    homepage = "https://github.com/dmulyalin/ttp_templates";
    changelog = "https://github.com/dmulyalin/ttp_templates/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
