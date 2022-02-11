{ lib, buildPythonPackage, fetchPypi, isPy27
, enum34, functools32, typing ? null
}:

buildPythonPackage rec {
  pname = "tomlkit";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "29e84a855712dfe0e88a48f6d05c21118dbafb283bb2eed614d46f80deb8e9a1";
  };

  propagatedBuildInputs =
    lib.optionals isPy27 [ enum34 functools32 ]
    ++ lib.optional isPy27 typing;

  # The Pypi tarball doesn't include tests, and the GitHub source isn't
  # buildable until we bootstrap poetry, see
  # https://github.com/NixOS/nixpkgs/pull/53599#discussion_r245855665
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/sdispater/tomlkit";
    description = "Style-preserving TOML library for Python";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
