{ lib
, buildPythonApplication
, fetchPypi
}:

buildPythonApplication rec {
  pname = "badchars";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1xqki8qnfwl97d60xj69alyzwa1mnfbwki25j0vhvhb05varaxz2";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "argparse" ""
  '';

  # no tests are available and it can't be imported (it's only a script, not a module)
  doCheck = false;

  meta = with lib; {
    description = "HEX badchar generator for different programming languages";
    longDescription = ''
      A HEX bad char generator to instruct encoders such as shikata-ga-nai to
      transform those to other chars.
    '';
    homepage = "https://github.com/cytopia/badchars";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
