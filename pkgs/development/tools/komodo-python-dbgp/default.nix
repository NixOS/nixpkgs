{
  stdenv,
  fetchFromGitHub,
  pythonPackages
}:

pythonPackages.buildPythonApplication rec {
  pname = "komodo-python-dbgp";
  version = "11.0";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "1r0b9kp66jm00y8paf0bnck3vf6wl5w0h8q4b8r8kj2cy94f7wg2";
  };

  meta = with stdenv.lib; {
    homepage = "https://github.com/agroszer/komodo-python-dbgp";
    description = "ActiveState Komodo's PyDBGp server";
    # https://github.com/agroszer/komodo-python-dbgp/blob/master/LICENSE.txt#L27
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
  };
}
