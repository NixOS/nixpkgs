{ lib
, buildPythonApplication
, fetchFromGitHub
<<<<<<< HEAD
, fetchpatch
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, boto3
}:

buildPythonApplication rec {
  pname = "aws-mfa";
  version = "0.0.12";
<<<<<<< HEAD
  format = "setuptools";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "broamski";
    repo = "aws-mfa";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-XhnDri7QV8esKtx0SttWAvevE3SH2Yj2YMq/P4K6jK4=";
  };

  patches = [
    # https://github.com/broamski/aws-mfa/pull/87
    (fetchpatch {
      name = "remove-duplicate-script.patch";
      url = "https://github.com/broamski/aws-mfa/commit/0d1624022c71cb92bb4436964b87f0b2ffd677ec.patch";
      hash = "sha256-Bv8ffPbDysz87wLg2Xip+0yxaBfbEmu+x6fSXI8BVjA=";
    })
  ];

=======
    sha256 = "1blcpa13zgyac3v8inc7fh9szxq2avdllx6w5ancfmyh5spc66ay";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    boto3
  ];

<<<<<<< HEAD
  # package has no tests
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  doCheck = false;

  pythonImportsCheck = [
    "awsmfa"
  ];

  meta = with lib; {
    description = "Manage AWS MFA Security Credentials";
    homepage = "https://github.com/broamski/aws-mfa";
<<<<<<< HEAD
    license = licenses.mit;
=======
    license = [ licenses.mit ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = [ maintainers.srapenne ];
  };
}
