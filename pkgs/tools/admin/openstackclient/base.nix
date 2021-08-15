{ lib, python3Packages }:

let
  openstackclient = optionalPlugins: python3Packages.buildPythonApplication rec {
    pname = "openstackclient";
    version = "5.5.0";

    src = python3Packages.fetchPypi {
      inherit version;
      pname = "python-${pname}";
      sha256 = "1058v5zqbgly5b6dn3ijcjjvbjxi60iaqhhnrrsr6bqpfh9ljh4d";
    };

    propagatedBuildInputs = with python3Packages; [
      pbr
      cliff
      iso8601
      openstacksdk
      osc-lib
      oslo-i18n
      oslo-utils
      stevedore
    ] ++ lib.unique ([
      # Required client plugins
      python-keystoneclient
      python-novaclient
      python-cinderclient
    ] ++ optionalPlugins);

    checkInputs = with python3Packages; [ stestr requests-mock ddt ];
    checkPhase = ''
      stestr run
    '';
    pythonImportsCheck = [ "openstackclient" ];

    meta = with lib; {
      description = "A command-line client for OpenStack";
      longDescription = "OpenStackClient (aka OSC) is a command-line client for OpenStack that brings the command set for Compute, Identity, Image, Network, Object Store and Block Storage APIs together in a single shell with a uniform command structure";
      homepage = "https://docs.openstack.org/python-openstackclient/latest/";
      license = licenses.asl20;
      maintainers = with maintainers; [ angustrau ];
    };
  };
  base = plugins: (openstackclient plugins) // { inherit withPlugins; };

  # Optional client plugins
  availablePlugins = with python3Packages; {
    inherit python-cinderclient python-keystoneclient python-novaclient;
  };
  withPlugins = f: base (f availablePlugins);
in
  { inherit withPlugins; }
