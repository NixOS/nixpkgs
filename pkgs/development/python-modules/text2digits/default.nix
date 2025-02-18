{
  buildPythonPackage,
  fetchPypi,
  lib,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "text2digits";
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oB2NyNVxediIulid9A4Ccw878t2JKrIsN1OOR5lyi7I=";
  };

  pythonImportsCheck = [
    "text2digits.text2digits"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = ''Converts text such as "twenty three" to number/digit "23" in any sentence'';
    homepage = "https://github.com/ShailChoksi/text2digits";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jwillikers ];
  };
}
