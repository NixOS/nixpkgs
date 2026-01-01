{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  ua-parser,
}:

buildPythonPackage rec {
  pname = "user-agents";
  version = "2.2.0";
  format = "setuptools";

  # PyPI is missing devices.json
  src = fetchFromGitHub {
    owner = "selwin";
    repo = "python-user-agents";
    rev = "v${version}";
    sha256 = "0pcbjqj21c2ixhl414bh2h8khi8y1igzfpkyqwan1pakix0lq45a";
  };

  propagatedBuildInputs = [ ua-parser ];

<<<<<<< HEAD
  meta = {
    description = "Python library to identify devices by parsing user agent strings";
    homepage = "https://github.com/selwin/python-user-agents";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ dotlambda ];
=======
  meta = with lib; {
    description = "Python library to identify devices by parsing user agent strings";
    homepage = "https://github.com/selwin/python-user-agents";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dotlambda ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
