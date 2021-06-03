{ lib, buildPythonPackage, fetchPypi, fetchpatch, mock
, future, six, setuptools-scm }:

buildPythonPackage rec {
  pname = "sievelib";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1sl1fnwr5jdacrrnq2rvzh4vv1dyxd3x31vnqga36gj8h546h7mz";
  };

  patches = [
    (fetchpatch {
      name = "pip-10-pip-req.patch";
      url = "https://github.com/tonioo/sievelib/commit/1deef0e2bf039a0e817ea6f19aaf1947dc9fafbc.patch";
      sha256 = "0vaj73mcij9dism8vfaai82irh8j1b2n8gf9jl1a19d2l26jrflk";
    })
    (fetchpatch {
      name = "requirements-in-setup-py.patch";
      url = "https://github.com/tonioo/sievelib/commit/91f40ec226ea288e98379da01672a46dabd89fc9.patch";
      sha256 = "0hph89xn16r353rg6f05bh0cgigmwdc736bya089qc03jhssrgns";
    })
  ];

  buildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ future six ];
  checkInputs = [ mock ];

  meta = {
    description = "Client-side Sieve and Managesieve library written in Python";
    homepage    = "https://github.com/tonioo/sievelib";
    license     = lib.licenses.mit;
    maintainers = with lib.maintainers; [ leenaars ];
    longDescription = ''
      A library written in Python that implements RFC 5228 (Sieve: An Email
      Filtering Language) and RFC 5804 (ManageSieve: A Protocol for
      Remotely Managing Sieve Scripts), as well as the following extensions:

       * Copying Without Side Effects (RFC 3894)
       * Body (RFC 5173)
       * Date and Index (RFC 5260)
       * Vacation (RFC 5230)
       * Imap4flags (RFC 5232)
    '';
  };
}
