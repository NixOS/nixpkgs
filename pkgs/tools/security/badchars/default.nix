{
  lib,
  buildPythonApplication,
  fetchPypi,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "badchars";
  version = "0.4.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4neV1S5gwQ03kEXEyZezNSj+PVXJyA5MO4lyZzGKE/c=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "argparse" ""
  '';

  build-system = with python3.pkgs; [
    setuptools
  ];

  # no tests are available and it can't be imported (it's only a script, not a module)
  doCheck = false;

  meta = with lib; {
    description = "HEX badchar generator for different programming languages";
    longDescription = ''
      A HEX bad char generator to instruct encoders such as shikata-ga-nai to
      transform those to other chars.
    '';
    homepage = "https://github.com/cytopia/badchars";
    changelog = "https://github.com/cytopia/badchars/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "badchars";
  };
}
