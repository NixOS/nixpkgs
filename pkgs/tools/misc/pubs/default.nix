{ stdenv, fetchFromGitHub, python3 }:

let
  python3Packages = (python3.override {
    packageOverrides = self: super: {
      # https://github.com/pubs/pubs/issues/131
      pyfakefs = super.pyfakefs.overridePythonAttrs (oldAttrs: rec {
        version = "3.3";
        src = self.fetchPypi {
          pname = "pyfakefs";
          inherit version;
          sha256 = "e3e198dea5e0d5627b73ba113fd0b139bb417da6bc15d920b2c873143d2f12a6";
        };
        postPatch = "";
        doCheck = false;
      });
    };
  }).pkgs;

in python3Packages.buildPythonApplication rec {
  pname = "pubs";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "pubs";
    repo = "pubs";
    rev = "v${version}";
    sha256 = "0n5wbjx9wqy6smfg625mhma739jyg7c92766biaiffp0a2bzr475";
  };

  propagatedBuildInputs = with python3Packages; [
    dateutil configobj bibtexparser pyyaml requests beautifulsoup4
  ];

  checkInputs = with python3Packages; [ pyfakefs ddt ];

  preCheck = ''
    # API tests require networking
    rm tests/test_apis.py

    # pyfakefs works weirdly in the sandbox
    export HOME=/
  '';

  meta = with stdenv.lib; {
    description = "Command-line bibliography manager";
    homepage = https://github.com/pubs/pubs;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ gebner ];
  };
}
