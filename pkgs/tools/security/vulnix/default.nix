{ lib
, python3Packages
<<<<<<< HEAD
, fetchPypi
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, nix
, ronn
}:

python3Packages.buildPythonApplication rec {
  pname = "vulnix";
  version = "1.10.1";

<<<<<<< HEAD
  src = fetchPypi {
=======
  src = python3Packages.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    inherit pname version;
    sha256 = "07v3ddvvhi3bslwrlin45kz48i3va2lzd6ny0blj5i2z8z40qcfm";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--flake8" ""
  '';

  outputs = [ "out" "doc" "man" ];
  nativeBuildInputs = [ ronn ];

  nativeCheckInputs = with python3Packages; [
    freezegun
    pytest
    pytest-cov
  ];

  propagatedBuildInputs = [
    nix
  ] ++ (with python3Packages; [
    click
    colorama
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

  meta = with lib; {
    description = "NixOS vulnerability scanner";
    homepage = "https://github.com/flyingcircusio/vulnix";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ckauhaus ];
  };
}
