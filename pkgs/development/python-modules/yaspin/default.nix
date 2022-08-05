################################################################################
# WARNING: Changes made to this file MUST go through the usual PR review process
#          and MUST be approved by a member of `meta.maintainers` before
#          merging. Commits attempting to circumvent the PR review process -- as
#          part of python-updates or otheriwse -- will be reverted without
#          notice.
################################################################################
{ buildPythonPackage
, fetchFromGitHub
, lib
, poetry-core
, termcolor
}:

buildPythonPackage rec {
  pname = "yaspin";
  version = "2.1.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pavdmyt";
    repo = pname;
    rev = "v${version}";
    sha256 = "0vhh4mp706kz5fba8nvr9jm51jsd32xj97m3law6ixw3lj91sh1a";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ termcolor ];

  pythonImportsCheck = [ "yaspin" ];

  meta = with lib; {
    description = "Yet Another Terminal Spinner";
    homepage = "https://github.com/pavdmyt/yaspin";
    license = licenses.mit;
    maintainers = with maintainers; [ samuela ];
  };
}
