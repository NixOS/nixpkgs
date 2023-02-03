{ lib
, buildPythonPackage
, factory_boy
, faker
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "tld";
  version = "0.12.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-tvdynhnODrx3ugpltw1iE665UsAf9gXhKZquX7diHF4=";
  };

  nativeCheckInputs = [
    factory_boy
    faker
    pytestCheckHook
  ];

  # these tests require network access, but disabledTestPaths doesn't work.
  # the file needs to be `import`ed by another python test file, so it
  # can't simply be removed.
  preCheck = ''
    echo > src/tld/tests/test_commands.py
  '';
  pythonImportsCheck = [ "tld" ];

  meta = with lib; {
    homepage = "https://github.com/barseghyanartur/tld";
    description = "Extracts the top level domain (TLD) from the URL given";
    # https://github.com/barseghyanartur/tld/blob/master/README.rst#license
    # MPL-1.1 OR GPL-2.0-only OR LGPL-2.1-or-later
    license = with licenses; [ lgpl21Plus mpl11 gpl2Only ];
    maintainers = with maintainers; [ fab ];
  };
}
