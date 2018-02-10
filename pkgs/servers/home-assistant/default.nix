{ stdenv, fetchFromGitHub, python3
, extraComponents ? []
, extraPackages ? ps: []
, skipPip ? true }:

let

  py = python3.override {
    packageOverrides = self: super: {
      yarl = super.yarl.overridePythonAttrs (oldAttrs: rec {
        version = "0.18.0";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "11j8symkxh0ngvpddqpj85qmk6p70p20jca3alxc181gk3vx785s";
        };
      });
      aiohttp = super.aiohttp.overridePythonAttrs (oldAttrs: rec {
        version = "2.3.7";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "0fzfpx5ny7559xrxaawnylq20dvrkjiag0ypcd13frwwivrlsagy";
        };
      });
      pytest = super.pytest.overridePythonAttrs (oldAttrs: rec {
        version = "3.3.1";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "14zbnbn53yvrpv79ch6n02myq9b4winjkaykzi356sfqb7f3d16g";
        };
      });
      hass-frontend = super.callPackage ./frontend.nix { };
    };
  };

  componentPackages = import ./component-packages.nix;

  availableComponents = builtins.attrNames componentPackages.components;

  getPackages = component: builtins.getAttr component componentPackages.components;

  componentBuildInputs = map (component: getPackages component py.pkgs) extraComponents;

  # Ensure that we are using a consistent package set
  extraBuildInputs = extraPackages py.pkgs;

  # Don't forget to run parse-requirements.py after updating
  hassVersion = "0.62.1";

in with py.pkgs; buildPythonApplication rec {
  pname = "homeassistant";
  version = assert (componentPackages.version == hassVersion); hassVersion;

  inherit availableComponents;

  # PyPI tarball is missing tests/ directory
  src = fetchFromGitHub {
    owner = "home-assistant";
    repo = "home-assistant";
    rev = version;
    sha256 = "0151prwk2ci6bih0mdmc3r328nrvazn9jwk0w26wmd4cpvnb5h26";
  };

  propagatedBuildInputs = [
    # From setup.py
    requests pyyaml pytz pip jinja2 voluptuous typing aiohttp yarl async-timeout chardet astral certifi
    # From the components that are part of the default configuration.yaml
    sqlalchemy aiohttp-cors hass-frontend user-agents distro mutagen xmltodict netdisco
  ] ++ componentBuildInputs ++ extraBuildInputs;

  checkInputs = [
    pytest requests-mock pydispatcher pytest-aiohttp
  ];

  checkPhase = ''
    # The components' dependencies are not included, so they cannot be tested
    py.test --ignore tests/components
    # Some basic components should be tested however
    py.test \
      tests/components/{group,http} \
      tests/components/test_{api,configurator,demo,discovery,frontend,init,introduction,logger,script,shell_command,system_log,websocket_api}.py
  '';

  makeWrapperArgs = [] ++ stdenv.lib.optional skipPip [ "--add-flags --skip-pip" ];

  meta = with stdenv.lib; {
    homepage = https://home-assistant.io/;
    description = "Open-source home automation platform running on Python 3";
    license = licenses.asl20;
    maintainers = with maintainers; [ f-breidenstein dotlambda ];
  };
}
