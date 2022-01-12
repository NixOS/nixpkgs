{ lib
, python3Packages
, onlykey-cli
}:

let
  # onlykey requires a patched version of libagent
  lib-agent = with python3Packages; libagent.overridePythonAttrs (oa: rec{
    version = "1.0.2";
    src = fetchPypi {
      inherit version;
      pname = "lib-agent";
      sha256 = "sha256-NAimivO3m4UUPM4JgLWGq2FbXOaXdQEL/DqZAcy+kEw=";
    };
    propagatedBuildInputs = oa.propagatedBuildInputs or [ ] ++ [
      pynacl
      docutils
      pycryptodome
      wheel
    ];

    # turn off testing because I can't get it to work
    doCheck = false;
    pythonImportsCheck = [ "libagent" ];

    meta = oa.meta // {
      description = "Using OnlyKey as hardware SSH and GPG agent";
      homepage = "https://github.com/trustcrypto/onlykey-agent/tree/ledger";
      maintainers = with maintainers; [ kalbasit ];
    };
  });
in
python3Packages.buildPythonApplication rec {
  pname = "onlykey-agent";
  version = "1.1.11";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "sha256-YH/cqQOVy5s6dTp2JwxM3s4xRTXgwhOr00whtHAwZZI=";
  };

  propagatedBuildInputs = with python3Packages; [ lib-agent onlykey-cli ];

  # move the python library into the sitePackages.
  postInstall = ''
    mkdir $out/${python3Packages.python.sitePackages}/onlykey_agent
    mv $out/bin/onlykey_agent.py $out/${python3Packages.python.sitePackages}/onlykey_agent/__init__.py
    chmod a-x $out/${python3Packages.python.sitePackages}/onlykey_agent/__init__.py
  '';

  # no tests
  doCheck = false;
  pythonImportsCheck = [ "onlykey_agent" ];

  meta = with lib; {
    description = " The OnlyKey agent is essentially middleware that lets you use OnlyKey as a hardware SSH/GPG device.";
    homepage = "https://github.com/trustcrypto/onlykey-agent";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ kalbasit ];
  };
}
