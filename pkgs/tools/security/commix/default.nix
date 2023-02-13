{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "commix";
  version = "3.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "commixproject";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-QdhJp7oUqOY8Z36haIrHgP4hVGaFXlOxNVg1ams7uhg=";
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
