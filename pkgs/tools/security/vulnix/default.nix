{ stdenv, pythonPackages, nix, ronn }:

pythonPackages.buildPythonApplication rec {
  pname = "vulnix";
  version = "1.8.2";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "0zn21j15vd1z7s40s45zr5wri3r770yvazxqmm60fqpzc5sg552y";
  };

  outputs = [ "out" "doc" "man" ];
  nativeBuildInputs = [ ronn ];

  checkInputs = with pythonPackages; [
    freezegun
    pytest
    pytestcov
    pytest-flake8
  ];

  propagatedBuildInputs = [
    nix
  ] ++ (with pythonPackages; [
    click
    colorama
    lxml
    pyyaml
    requests
    setuptools
    toml
    zodb
  ]);

  postBuild = "make -C doc";

  checkPhase = "py.test src/vulnix";

  postInstall = ''
    install -D -t $doc/share/doc/vulnix README.rst CHANGES.rst
    gzip $doc/share/doc/vulnix/*.rst
    install -D -t $man/share/man/man1 doc/vulnix.1
    install -D -t $man/share/man/man5 doc/vulnix-whitelist.5
  '';

  dontStrip = true;

  meta = with stdenv.lib; {
    description = "NixOS vulnerability scanner";
    homepage = https://github.com/flyingcircusio/vulnix;
    license = licenses.bsd3;
    maintainers = with maintainers; [ ckauhaus plumps ];
  };
}
