{ lib, fetchFromGitHub, pythonPackages, buildPythonPackage }:

buildPythonPackage rec {
  pname = "cookbook";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "strangeglyph";
    repo = "cookbook";
    rev = "v${version}";
    sha256 = "sha256-ylpQweY1uhzk8vINGGNrQpS/jkVnAWeY9YZfD/i3zdE=";
  };

  propagatedBuildInputs = with pythonPackages; [ flask ruamel-yaml ];

  pythonImportsCheck = [ "flask" "ruamel.yaml" ];
  doCheck = false; # the package provides no checks

  postInstall = ''
    cp -r $src/cookbook/static $out/static
    echo "from cookbook import app" > $out/wsgi.py
  '';

  meta = with lib; {
    homepage = "https://github.com/strangeglyph/cookbook";
    description = "Flask application to serve recipes";
    license = licenses.mit;
    maintainers = [ maintainers.strangeglyph ];
  };
}
