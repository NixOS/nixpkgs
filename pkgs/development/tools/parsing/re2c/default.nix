{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, nix-update-script
, python3

# for passthru.tests
, ninja
, php
, spamassassin
}:

stdenv.mkDerivation rec {
  pname = "re2c";
  version = "3.1";

  src = fetchFromGitHub {
    owner  = "skvadrik";
    repo   = "re2c";
    rev    = version;
    sha256 = "sha256-7zZdLby7HdNoURgdkg+xnlp6VDCACcyGCTtjM43OLd4=";
  };

  nativeBuildInputs = [
    autoreconfHook
    python3
  ];

  doCheck = true;
  enableParallelBuilding = true;

  preCheck = ''
    patchShebangs run_tests.py
  '';

  passthru = {
    updateScript = nix-update-script {
      # Skip non-release tags like `python-experimental`.
      extraArgs = [ "--version-regex" "([0-9.]+)" ];
    };
    tests = {
      inherit ninja php spamassassin;
    };
  };

  meta = with lib; {
    description = "Tool for writing very fast and very flexible scanners";
    homepage    = "https://re2c.org";
    license     = licenses.publicDomain;
    platforms   = platforms.all;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
