{ lib
, python3Packages
, onlykey-cli
}:

let
  bech32 = with python3Packages; buildPythonPackage rec {
    pname = "bech32";
    version = "1.2.0";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-fW24IUYDvXhx/PpsCCbvaLhbCr2Q+iHChanF4h0r2Jk=";
    };
  };

  # onlykey requires a patched version of libagent
  lib-agent = with python3Packages; libagent.overridePythonAttrs (oa: rec{
    version = "1.0.4";
    src = fetchPypi {
      inherit version;
      pname = "lib-agent";
      sha256 = "sha256-MwtufyJVPWuK7bbX+9Kv6wEi/zq4ftXrfjrMOYpcIfc=";
    };
    propagatedBuildInputs = oa.propagatedBuildInputs or [ ] ++ [
      bech32
      cryptography
      docutils
      pycryptodome
      pynacl
      wheel
    ];

    # turn off testing because I can't get it to work
    doCheck = false;
    pythonImportsCheck = [ "libagent" ];

    meta = oa.meta // {
      description = "Using OnlyKey as hardware SSH and GPG agent";
      homepage = "https://github.com/trustcrypto/onlykey-agent/tree/ledger";
      maintainers = with lib.maintainers; [ kalbasit ];
    };
  });
in
python3Packages.buildPythonApplication rec {
  pname = "onlykey-agent";
  version = "1.1.13";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "sha256-GAb6crtW6rLAbFtdi6fAGCPjXpKFhravguoGjuNcIxc=";
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
