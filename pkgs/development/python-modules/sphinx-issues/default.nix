{
  stdenv,
  lib,
  buildPythonPackage,
  sphinx,
  fetchFromGitHub,
  pandoc,
  enableManpages ? !stdenv.buildPlatform.isRiscV64,
}:

buildPythonPackage rec {
  pname = "sphinx-issues";
  version = "3.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "sloria";
    repo = "sphinx-issues";
    tag = version;
    hash = "sha256-CsJDeuHX11+UaqrEvLNOvcXjjkj+cUk+4ozPhHU02tI=";
  };

  outputs =
    [
      "out"
    ]
    ++ lib.optionals enableManpages [
      "doc"
    ];

  dependencies = [ sphinx ];

  nativeBuildInputs = lib.optionals enableManpages [ pandoc ];

  postBuild = lib.optionalString enableManpages ''
    pandoc -f rst -t html --standalone < README.rst > README.html
  '';

  postInstall = lib.optionalString enableManpages ''
    mkdir -p $doc/share/doc/$name/html
    cp README.html $doc/share/doc/$name/html
  '';

  pythonImportsCheck = [ "sphinx_issues" ];

  meta = {
    homepage = "https://github.com/sloria/sphinx-issues";
    description = "Sphinx extension for linking to your project's issue tracker";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kaction ];
  };
}
