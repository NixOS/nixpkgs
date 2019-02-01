{ stdenv, lib, buildPythonPackage, isPyPy, fetchFromGitHub
, six, social-auth-core }:

buildPythonPackage rec {
  pname = "social-auth-app-django";
  version = "3.1.0";

  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "python-social-auth";
    repo = "social-app-django";
    rev = version;
    sha256 = "1h0hc83pfjm1wn6ylypkfcrwn4rf530nsyjnwgv4h5n80n8vkyha";
  };

  # checkInputs = [ mock django ];

  propagatedBuildInputs = [ six social-auth-core ];

  # manage.py failed to setup DJANGO_SETTINGS_MODULE (i guess path issue?)
  doCheck = false;

  meta = with lib; {
    description = "social authentication/registration mechanism with support for several frameworks and auth providers";
    homepage = https://github.com/python-social-auth/social-app-django;
    maintainers= with maintainers; [ peterromfeldhk ];
    # license = with licenses; [ ??? ]; no idea what license this is
  };
}
