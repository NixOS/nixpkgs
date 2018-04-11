{ lib, fetchFromGitHub, python3
, extraComponents ? []
, extraPackages ? ps: []
, skipPip ? true }:

let

  py = python3.override {
    packageOverrides = self: super: {
      aiohttp = super.aiohttp.overridePythonAttrs (oldAttrs: rec {
        version = "3.0.9";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "281a9fa56b5ce587a2147ec285d18a224942f7e020581afa6cc44d7caecf937b";
        };
      });
      pytest = super.pytest.overridePythonAttrs (oldAttrs: rec {
        version = "3.4.2";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "117bad36c1a787e1a8a659df35de53ba05f9f3398fb9e4ac17e80ad5903eb8c5";
        };
      });
      voluptuous = super.voluptuous.overridePythonAttrs (oldAttrs: rec {
        version = "0.11.1";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "af7315c9fa99e0bfd195a21106c82c81619b42f0bd9b6e287b797c6b6b6a9918";
        };
      });
      astral = super.astral.overridePythonAttrs (oldAttrs: rec {
        version = "1.6";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "874b397ddbf0a4c1d8d644b21c2481e8a96b61343f820ad52d8a322d61a15083";
        };
      });
      async-timeout = super.async-timeout.overridePythonAttrs (oldAttrs: rec {
        version = "2.0.1";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "00cff4d2dce744607335cba84e9929c3165632da2d27970dbc55802a0c7873d0";
        };
      });
      hass-frontend = super.callPackage ./frontend.nix { };
    };
  };

  componentPackages = import ./component-packages.nix;

  availableComponents = builtins.attrNames componentPackages.components;

  getPackages = component: builtins.getAttr component componentPackages.components;

  componentBuildInputs = lib.concatMap (component: getPackages component py.pkgs) extraComponents;

  # Ensure that we are using a consistent package set
  extraBuildInputs = extraPackages py.pkgs;

  # Don't forget to run parse-requirements.py after updating
  hassVersion = "0.66.1";

in with py.pkgs; buildPythonApplication rec {
  pname = "homeassistant";
  version = assert (componentPackages.version == hassVersion); hassVersion;

  disabled = pythonOlder "3.5";

  inherit availableComponents;

  # PyPI tarball is missing tests/ directory
  src = fetchFromGitHub {
    owner = "home-assistant";
    repo = "home-assistant";
    rev = version;
    sha256 = "16yz5mfzpfms22f8linw1k3wjp3jpwj270vy2rc893x9bzsppfl0";
  };

  propagatedBuildInputs = [
    # From setup.py
    requests pyyaml pytz pip jinja2 voluptuous typing aiohttp async-timeout astral certifi attrs
    # From http, frontend and recorder components
    sqlalchemy aiohttp-cors hass-frontend
  ] ++ componentBuildInputs ++ extraBuildInputs;

  checkInputs = [
    pytest requests-mock pydispatcher pytest-aiohttp
  ];

  checkPhase = ''
    # The components' dependencies are not included, so they cannot be tested
    py.test --ignore tests/components
    # Some basic components should be tested however
    # test_not_log_password fails because nothing is logged at all
    py.test -k "not test_not_log_password" \
      tests/components/{group,http} \
      tests/components/test_{api,configurator,demo,discovery,frontend,init,introduction,logger,script,shell_command,system_log,websocket_api}.py
  '';

  makeWrapperArgs = lib.optional skipPip "--add-flags --skip-pip";

  meta = with lib; {
    homepage = https://home-assistant.io/;
    description = "Open-source home automation platform running on Python 3";
    license = licenses.asl20;
    maintainers = with maintainers; [ f-breidenstein dotlambda ];
  };
}
