{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  unittestCheckHook,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "thorlabspm100";
  version = "1.2.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "clade";
    repo = "ThorlabsPM100";
    rev = "v${version}";
    hash = "sha256-X4qEow6u4aE0sbFwZfK3YEso2RS0c9j4iaWJPHaPQV4=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "ThorlabsPM100" ];

  meta = with lib; {
    description = "Interface to the PM100A/D power meter from Thorlabs";
    homepage = "https://github.com/clade/ThorlabsPM100/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fsagbuya ];
  };
}
