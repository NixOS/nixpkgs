{ lib, buildPythonApplication, fetchFromGitHub, isPy3k
, opentimestamps, appdirs, GitPython, pysocks, fetchpatch, git
}:

buildPythonApplication rec {
  pname = "opentimestamps-client";
  version = "0.6.0";
  disabled = (!isPy3k);

  # We can't use the pypi source because it doesn't include README.md which is
  # needed in setup.py
  src = fetchFromGitHub {
    owner = "opentimestamps";
    repo = "opentimestamps-client";
    rev = "opentimestamps-client-v${version}";
    sha256 = "05m8nllqad3k69mvby5q08y22i0wrj84gqifdgcldimrrn1i00xp";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/opentimestamps/opentimestamps-client/commit/1b328269ceee66916e9a639e8d5d7d13cd70d5d8.patch";
      sha256 = "0bd3yalyvk5n4sflw9zilpay5k653ybdgkkfppyrk7c8z3i81hbl";
    })
  ];

  checkInputs = [ git ];

  propagatedBuildInputs = [ opentimestamps appdirs GitPython pysocks ];

  meta = {
    description = "Command-line tool to create and verify OpenTimestamps proofs";
    homepage = https://github.com/opentimestamps/opentimestamps-client;
    license = lib.licenses.lgpl3;
  };
}
