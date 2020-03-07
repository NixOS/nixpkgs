{ lib, buildPythonPackage, fetchPypi, isPy27, isPy34
, enum34, functools32, typing
}:

buildPythonPackage rec {
  pname = "tomlkit";
  version = "0.5.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1kq1663iqxgwrmb883n55ypi5axnixla2hrby9g2x227asifsi7h";
  };

  propagatedBuildInputs =
    lib.optionals isPy27 [ enum34 functools32 ]
    ++ lib.optional (isPy27 || isPy34) typing;

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
