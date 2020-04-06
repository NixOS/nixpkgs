{ lib, stdenv, buildPythonPackage, python, fetchFromGitHub, attrs, cryptography, async-timeout, pytest-aiohttp, pytest }:

buildPythonPackage rec {
  pname = "snitun";
  version = "0.20";

  src = fetchFromGitHub {
    owner = "NabuCasa";
    repo = pname;
    rev = version;
    sha256 = "1nscfwycclfbll709w1q46w6rl0r5c3b85rsc7zwc3ixd1k8aajp";
  };

  propagatedBuildInputs = [ attrs cryptography async-timeout ];

  checkInputs = [ pytest pytest-aiohttp ];

  checkPhase = ''
    # https://github.com/NabuCasa/snitun/issues/61
    pytest ${lib.optionalString stdenv.isDarwin "-k 'not test_multiplexer_data_channel_abort_full'"} tests/
  '';

  meta = with lib; {
    homepage = "https://github.com/nabucasa/snitun";
    description = "SNI proxy with TCP multiplexer";
    license = licenses.gpl3;
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}
