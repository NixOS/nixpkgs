{ stdenv, lib, buildPythonPackage, isPyPy, fetchFromGitHub
, six, requests_oauthlib, python3-openid }:

buildPythonPackage rec {
  pname = "social-auth-core";
  version = "3.0.0";


  src = fetchFromGitHub {
    owner = "python-social-auth";
    repo = "social-core";
    rev = version;
    sha256 = "0kf6swarf0pipx6mxxww7iqfj02agpm8c3c0qm59h71xawl93syk";
  };

  # checkInputs = [ xmlsec pkgconfig libxml2 ];

  propagatedBuildInputs = [ six requests_oauthlib python3-openid ];

  # im stuck with `Could not find xmlsec1 config. Are libxmlsec1-dev and pkg-config installed?`
  doCheck = false;

  meta = with lib; {
    description = "social authentication/registration mechanism with support for several frameworks and auth providers";
    homepage = https://github.com/python-social-auth/social-core;
    maintainers= with maintainers; [ peterromfeldhk ];
    # license = with licenses; [ ??? ]; no idea what license this is
  };
}
