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
    rev = "7be76e73969a8b9c993903681b300e1dd32f4b4d";
    sha256 = "1qsqzm5iswgv9jrflh5mvbz9a7js7jf42cb28lzdzsp45iwfs2aa";
  };
  version = "git-2018-05-27";

  # Build helper to build a single datadog integration package.
  buildIntegration = { pname, ... }@args: python.pkgs.buildPythonPackage (args // {
    inherit src version;
    name = "datadog-integration-${pname}-${version}";

    postPatch = ''
      # jailbreak install_requires
      sed -i 's/==.*//' requirements.in
      cp requirements.in requirements.txt
    '';
    sourceRoot = "source/${args.sourceRoot or pname}";
    doCheck = false;
  });

  # Base package depended on by all other integrations.
  datadog_checks_base = buildIntegration {
    pname = "checks-base";
    sourceRoot = "datadog_checks_base";
    propagatedBuildInputs = with python.pkgs; [
      requests protobuf prometheus_client uuid simplejson uptime
    ];
  };

  # Default integrations that should be built:
  defaultIntegrations = {
    disk     = (ps: [ ps.psutil ]);
    mongo    = (ps: [ ps.pymongo ]);
    network  = (ps: [ ps.psutil ]);
    nginx    = (ps: []);
    postgres = (ps: with ps; [ pg8000 psycopg2 ]);
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
