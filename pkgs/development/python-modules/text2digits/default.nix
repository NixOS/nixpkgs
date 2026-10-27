{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "text2digits";
  version = "0.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ShailChoksi";
    repo = "text2digits";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OswtDg8ZVKJe0SaSo+4CUZdGh8fbFsr+tDntj2FLq/k=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "text2digits" ];

  meta = {
    description = "Converts text such as 'twenty three' to number/digit '23' in any sentence";
    homepage = "https://github.com/ShailChoksi/text2digits";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getchoo ];
  };
})
