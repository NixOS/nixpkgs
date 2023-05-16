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
<<<<<<< HEAD
  version = "3.1";
=======
  version = "3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner  = "skvadrik";
    repo   = "re2c";
    rev    = version;
<<<<<<< HEAD
    sha256 = "sha256-7zZdLby7HdNoURgdkg+xnlp6VDCACcyGCTtjM43OLd4=";
=======
    sha256 = "sha256-ovwmltu97fzNQT0oZHefrAo4yV9HV1NwcY4PTSM5Bro=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    updateScript = nix-update-script { };
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
