{ lib, fetchFromGitHub, buildPythonPackage, isPy27
, awkward0, backports_lzma ? null, cachetools, lz4, pandas
, pytestCheckHook, pkgconfig, mock
, numpy, requests, uproot3-methods, xxhash, zstandard
}:

buildPythonPackage rec {
  pname = "uproot3";
  version = "3.14.4";

  src = fetchFromGitHub {
    owner = "scikit-hep";
    repo = "uproot3";
    rev = version;
    sha256 = "sha256-hVJpKdYvyoCPyqgZzKYp30SvkYm+HWSNBdd9bYCYACE=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner"' ""
  '';

  propagatedBuildInputs = [
    awkward0
    cachetools
    lz4
    numpy
    uproot3-methods
    xxhash
    zstandard
  ] ++ lib.optional isPy27 backports_lzma;

  checkInputs = [
    mock
    pandas
    pkgconfig
    pytestCheckHook
    requests
  ] ++ lib.optional isPy27 backports_lzma;

  meta = with lib; {
    homepage = "https://github.com/scikit-hep/uproot3";
    description = "ROOT I/O in pure Python and Numpy";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ktf SuperSandro2000 ];
  };
}
