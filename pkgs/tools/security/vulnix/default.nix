{ stdenv, pythonPackages, nix, ronn }:

pythonPackages.buildPythonApplication rec {
  pname = "vulnix";
  version = "1.7";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "16228w0vakb515cnrk4akadh0m21abiv8rv574jarcsf7359xslj";
  };

  buildInputs = [ ronn ];

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
    toml
    zodb
  ]);

  outputs = [ "out" "doc" ];

  postBuild = "make -C doc";

  checkPhase = "py.test src/vulnix";

  postInstall = ''
    install -D -t $out/share/man/man1 doc/vulnix.1
    install -D -t $out/share/man/man5 doc/vulnix-whitelist.5
    install -D -t $doc/share/doc/vulnix README.rst CHANGES.rst
    gzip $doc/share/doc/vulnix/*.rst
  '';

  dontStrip = true;

  meta = with stdenv.lib; {
    description = "NixOS vulnerability scanner";
    homepage = https://github.com/flyingcircusio/vulnix;
    license = licenses.bsd3;
    maintainers = with maintainers; [ ckauhaus plumps ];
  };
}
