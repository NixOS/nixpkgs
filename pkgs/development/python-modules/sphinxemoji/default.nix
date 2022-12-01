{ lib, buildPythonPackage, fetchFromGitHub, sphinx }:

buildPythonPackage rec {
  pname = "sphinxemoji";
  version = "0.2.0";

  outputs = [ "out" "doc" ];

  src = fetchFromGitHub {
    owner = "sphinx-contrib";
    repo = "emojicodes"; # does not match pypi name
    rev = "v${version}";
    sha256 = "sha256-TLhjpJpUIoDAe3RZ/7sjTgdW+5s7OpMEd1/w0NyCQ3A=";
  };

  propagatedBuildInputs = [ sphinx ];

  nativeBuildInputs = [ sphinx ];

  postBuild = ''
    PYTHONPATH=$PWD:$PYTHONPATH make -C docs html
  '';

  postInstall = ''
    mkdir -p $out/share/doc/python/$pname
    cp -r ./docs/build/html $out/share/doc/python/$pname
  '';

  pythonImportsCheck = [ "sphinxemoji" ];

  meta = with lib; {
    description = "Extension to use emoji codes in your Sphinx documentation";
    homepage = "https://github.com/sphinx-contrib/emojicodes";
    license = licenses.mit;
    maintainers = with maintainers; [ kaction ];
  };
}
