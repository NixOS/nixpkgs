{ lib
, python3
, fetchFromGitHub
}:

let
  py = python3.override {
    packageOverrides = self: super: {
      fido2 = super.fido2.overridePythonAttrs (oldAttrs: rec {
        version = "0.9.3";
        src = self.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          hash = "sha256-tF6JphCc/Lfxu1E3dqotZAjpXEgi+DolORi5RAg0Zuw=";
        };
      });

      configparser = super.configparser.overridePythonAttrs (oldAttrs: rec {
        version = "3.8.1";
        src = self.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          hash = "sha256-vDeFDwzEKhclp5bvfZJpBlG/GvN9dEzGMWHaxiyr7hc=";
        };
        doCheck = false;
      });

      python-dateutil = super.python-dateutil.overridePythonAttrs (oldAttrs: rec {
        version = "2.8.1";
        src = self.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          hash = "sha256-c+v+nb8i6DIoba+mBHPkzSOfhZL2mapa2vEAUObhgjw=";
        };
      });

      okta = super.okta.overridePythonAttrs (oldAttrs: rec {
        version = "0.0.4";
        src = self.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          hash = "sha256-U+eSxo02hP9BQLTLHAKvOCEJA2j4EQ/eVMC9tjhEkzI=";
        };
        propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [
          self.python-dateutil
          self.requests
        ];
        pythonImportsCheck = [ "okta" ];
        doCheck = false;
      });
    };
  };
in
with py.pkgs; buildPythonApplication rec {
  pname = "gimme-aws-creds";
  version = "2.4.4"; # N.B: if you change this, check if overrides are still up-to-date
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Nike-Inc";
    repo = "gimme-aws-creds";
    rev = "v${version}";
    hash = "sha256-XjxJhcvwmtoufsjoDaFHKMJaogVN/j29BXwdBd5GAAc=";
  };

  propagatedBuildInputs = [
    boto3
    python-dateutil
    fido2
    beautifulsoup4
    ctap-keyring-device
    configparser
    requests
    okta
  ];

  checkInputs = [
    nose
    responses
  ];

  checkPhase = ''
    nosetests --exclude="test_build_factor_name_webauthn_registered" tests/
  '';

  pythonImportsCheck = [
    "gimme_aws_creds"
  ];

  postInstall = ''
    rm $out/bin/gimme-aws-creds.cmd
  '';

  meta = with lib; {
    homepage = "https://github.com/Nike-Inc/gimme-aws-creds";
    changelog = "https://github.com/Nike-Inc/gimme-aws-creds/releases";
    description = "A CLI that utilizes Okta IdP via SAML to acquire temporary AWS credentials";
    license = licenses.asl20;
    maintainers = with maintainers; [ dennajort ];
    mainProgram = "gimme-aws-creds";
  };
}
