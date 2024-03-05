{ lib, buildPythonPackage, sphinx, fetchFromGitHub, pandoc }:

buildPythonPackage rec {
  pname = "sphinx-issues";
  version = "3.0.1";
  format = "setuptools";
  outputs = [ "out" "doc" ];

  src = fetchFromGitHub {
    owner = "sloria";
    repo = "sphinx-issues";
    rev = version;
    sha256 = "1lns6isq9kwcw8z4jwgy927f7idx9srvri5adaa5zmypw5x47hha";
  };

  pythonImportsCheck = [ "sphinx_issues" ];

  propagatedBuildInputs = [ sphinx ];

  nativeBuildInputs = [ pandoc ];

  postBuild = ''
    pandoc -f rst -t html --standalone < README.rst > README.html
  '';

  postInstall = ''
    mkdir -p $doc/share/doc/$name/html
    cp README.html $doc/share/doc/$name/html
  '';

  meta = with lib; {
    homepage = "https://github.com/sloria/sphinx-issues";
    description = "Sphinx extension for linking to your project's issue tracker.";
    license = licenses.mit;
    maintainers = with maintainers; [ kaction ];
  };
}
