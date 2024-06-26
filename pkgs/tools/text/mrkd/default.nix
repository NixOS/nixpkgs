{ lib
, python3
, fetchPypi
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      # https://github.com/refi64/mrkd/pull/6
      mistune = super.mistune.overridePythonAttrs (old: rec {
        version = "0.8.4";
        src = fetchPypi {
          inherit (old) pname;
          inherit version;
          hash = "sha256-WaNCnbU8ULXGvMigf4hIywDX3IvbQxpKtBkg0gHUdW4=";
        };
        meta = old.meta // {
          knownVulnerabilities = [
            "CVE-2022-34749"
          ];
        };
      });
    };
  };
in python.pkgs.buildPythonApplication rec {
  pname = "mrkd";
  version = "0.2.0";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "456f8c1be99da268554b29c6b5383532e58119def5a65d85270bc6a0ecc26aaf";
  };

  propagatedBuildInputs = with python.pkgs; [
    jinja2
    mistune
    pygments
    setuptools
  ];

  pythonImportsCheck = [ "mrkd" ];

  meta = with lib; {
    description = "Write man pages using Markdown, and convert them to Roff or HTML";
    homepage = "https://github.com/refi64/mrkd";
    license = licenses.bsd2;
    mainProgram = "mrkd";
    maintainers = with maintainers; [ prusnak ];
  };
}
