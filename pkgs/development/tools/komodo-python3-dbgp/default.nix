{
  stdenv,
  fetchFromGitHub,
  python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "komodo-python3-dbgp";
  version = "11.1.1";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "11ndpihpass7bpq5v61klvkhvnydqkr8mpdl24bkw2h6k46dzlci";
  };

  meta = with stdenv.lib; {
    homepage = "https://github.com/agroszer/komodo-python3-dbgp";
    description = "ActiveState Komodo's PyDBGp server";
    # https://github.com/agroszer/komodo-python3-dbgp/blob/master/LICENSE.txt#L27
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
  };
}
