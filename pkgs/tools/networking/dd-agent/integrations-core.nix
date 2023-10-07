# The declarations in this file build the Datadog agent's core
# integrations. These integrations are tracked in a separate
# repository[1] outside of the agent's primary repository and provide
# checks for various kinds of services.
#
# Not all services are relevant for all users, however. As some of
# them depend on various tools and Python packages it is nonsensical
# to build *all* integrations by default.
#
# A set of default integrations is defined and built either way.
# Additional integrations can be specified by overriding
# `extraIntegrations` in datadog-integrations-core.
#
# In practice the syntax for using this with additional integrations
# is not the most beautiful, but it works. For example to use
# datadog-agent from the top-level with the `ntp`-integration
# included, one could say:
#
# let
#   integrationsWithNtp = datadog-integrations-core {
#     # Extra integrations map from the integration name (as in the
#     # integrations-core repository) to a function that receives the
#     # Python package set and returns the required dependencies.g
#     ntp = (ps: [ ps.ntplib ]);
#   };
#
# in ddAgentWithNtp = datadog-agent.overrideAttrs(_ : {
#   python = integrationsWithNtp.python;
# });
#
# The NixOS module 'datadog-agent' provides a simplified interface to
# this. Please see the module itself for more information.
#
# [1]: https://github.com/DataDog/integrations-core

{ pkgs, python, extraIntegrations ? {} }:

with pkgs.lib;

let
  src = pkgs.fetchFromGitHub {
    owner = "DataDog";
    repo = "integrations-core";
    rev = version;
    sha256 = "sha256-CIzuJ97KwsG1k65Y+8IUSka/3JX1pmQKN3hPHzZnGhQ=";
  };
  version = "7.38.0";

  # Build helper to build a single datadog integration package.
  buildIntegration = { pname, ... }@args: python.pkgs.buildPythonPackage (args // {
    inherit src version;
    name = "datadog-integration-${pname}-${version}";

    sourceRoot = "${src.name}/${args.sourceRoot or pname}";
    doCheck = false;
  });

  # Base package depended on by all other integrations.
  datadog_checks_base = buildIntegration {
    pname = "checks-base";
    sourceRoot = "datadog_checks_base";

    # Make setuptools build the 'base' and 'checks' modules.
    postPatch = ''
      substituteInPlace setup.py \
        --replace "from setuptools import setup" "from setuptools import find_packages, setup" \
        --replace "packages=['datadog_checks']" "packages=find_packages()"
    '';

    propagatedBuildInputs = with python.pkgs; [
      binary
      cachetools
      cryptography
      immutables
      jellyfish
      prometheus-client
      protobuf
      pydantic
      python-dateutil
      pyyaml
      requests
      requests-toolbelt
      requests-unixsocket
      simplejson
      uptime
      wrapt
    ];

    pythonImportsCheck = [
      "datadog_checks.base"
      "datadog_checks.base.checks"
      "datadog_checks.checks"
    ];
  };

  # Default integrations that should be built:
  defaultIntegrations = {
    disk     = (ps: [ ps.psutil ]);
    mongo    = (ps: [ ps.pymongo ]);
    network  = (ps: [ ps.psutil ]);
    nginx    = (ps: []);
    postgres = (ps: with ps; [ pg8000 psycopg2 semver ]);
    process  = (ps: [ ps.psutil]);
  };

  # All integrations (default + extra):
  integrations = defaultIntegrations // extraIntegrations;
  builtIntegrations = mapAttrs (pname: fdeps: buildIntegration {
    inherit pname;
    propagatedBuildInputs = (fdeps python.pkgs) ++ [ datadog_checks_base ];
  }) integrations;

in builtIntegrations // {
  inherit datadog_checks_base;
  python = python.withPackages (_: (attrValues builtIntegrations));
}
