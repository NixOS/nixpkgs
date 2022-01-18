{ lib, buildPythonPackage, fetchFromGitHub
, matplotlib
, mock
, numpy
, pillow
, cython
, pytest-cov
, pytest
, fetchpatch
}:

buildPythonPackage rec {
  pname = "word_cloud";
  version = "1.8.1";

  # tests are not included in pypi tarball
  src = fetchFromGitHub {
    owner = "amueller";
    repo = pname;
    rev = version;
    sha256 = "sha256-4EFQfv+Jn9EngUAyDoJP0yv9zr9Tnbrdwq1YzDacB9Q=";
  };

  nativeBuildInputs = [ cython ];
  propagatedBuildInputs = [ matplotlib numpy pillow ];

  # Tests require extra dependencies
  checkInputs = [ mock pytest pytest-cov ];

  checkPhase = ''
    PATH=$out/bin:$PATH pytest test
  '';

  patches = [
    (fetchpatch {
      # https://github.com/amueller/word_cloud/pull/616
      url = "https://github.com/amueller/word_cloud/commit/858a8ac4b5b08494c1d25d9e0b35dd995151a1e5.patch";
      sha256 = "sha256-+aDTMPtOibVwjPrRLxel0y4JFD5ERB2bmJi4zRf/asg=";
    })
  ];

  meta = with lib; {
    description = "A little word cloud generator in Python";
    homepage = "https://github.com/amueller/word_cloud";
    license = licenses.mit;
    maintainers = with maintainers; [ jm2dev ];
  };
}
