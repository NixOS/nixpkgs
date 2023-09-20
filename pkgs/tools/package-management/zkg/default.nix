{ lib
, python3
, fetchFromGitHub
, pkgs
}:

python3.pkgs.buildPythonApplication rec {
  pname = "zkg";
  version = "2.13.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "zeek";
    repo = "package-manager";
    rev = "refs/tags/v${version}";
    hash = "sha256-kQFm8VlbvJ791Ll8b0iu6xqaxhYTf41jTmvGxLgIzuE=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    btest
    gitpython
    semantic-version
    sphinx
    sphinx-rtd-theme
    pkgs.bash
  ];

  # No tests available
  doCheck = false;

  pythonImportsCheck = [
    "zeekpkg"
  ];

  meta = with lib; {
    description = "Package manager for Zeek";
    homepage = "https://github.com/zeek/package-manager";
    changelog = "https://github.com/zeek/package-manager/blob/${version}/CHANGES";
    license = licenses.ncsa;
    maintainers = with maintainers; [ fab ];
  };
}
