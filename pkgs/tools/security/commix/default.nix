{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "commix";
<<<<<<< HEAD
  version = "3.8";
=======
  version = "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "commixproject";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-S/2KzZb3YUF0VJharWV/+7IG+r1EnB2sOveMpd1ryEI=";
=======
    hash = "sha256-pqfb0CkWTPq6B8T7nn25lWuEQFRRziCDWYm5a1S3mIY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postInstall = ''
    # Helper files are not handled by setup.py
    mkdir -p $out/${python3.sitePackages}/src/txt
    install -vD src/txt/* $out/${python3.sitePackages}/src/txt/
  '';

  # Project has no tests
  doCheck = false;

  meta = with lib; {
    description = "Automated Command Injection Exploitation Tool";
    homepage = "https://github.com/commixproject/commix";
    changelog = "https://github.com/commixproject/commix/releases/tag/v${version}";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
