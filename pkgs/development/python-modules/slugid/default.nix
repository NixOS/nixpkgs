{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "slugid";
  version = "2.0.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "taskcluster";
    repo = "slugid.py";
    rev = "v${version}";
    sha256 = "McBxGRi8KqVhe2Xez5k4G67R5wBCCoh41dRsTKW4xMA=";
  };

  doCheck = false; # has no tests

  pythonImportsCheck = [ "slugid" ];

<<<<<<< HEAD
  meta = {
    description = "URL-safe base64 UUID encoder for generating 22 character slugs";
    homepage = "https://github.com/taskcluster/slugid.py";
    license = lib.licenses.mpl20;
=======
  meta = with lib; {
    description = "URL-safe base64 UUID encoder for generating 22 character slugs";
    homepage = "https://github.com/taskcluster/slugid.py";
    license = licenses.mpl20;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
