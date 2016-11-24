{ stdenv, fetchurl, pythonPackages }:

with stdenv.lib;

pythonPackages.buildPythonApplication rec {
  name = "magic-wormhole-${version}";
  version = "0.8.1";

  src = fetchurl {
    url = "mirror://pypi/m/magic-wormhole/${name}.tar.gz";
    sha256 = "1yh5nbhh9z1am2pqnb5qqyq1zjl1m7z6jnkmvry2q14qwspw9had";
  };
  checkPhase = ''
    ${pythonPackages.python.interpreter} -m wormhole.test.run_trial wormhole
  '';

  propagatedBuildInputs = with pythonPackages; [ autobahn cffi click hkdf pynacl spake2 tqdm ];
  meta = {
    description = "Securely transfer data between computers";
    homepage = "https://github.com/warner/magic-wormhole";
    license = licenses.mit;
    maintainers = with maintainers; [ asymmetric ];
  };
}
