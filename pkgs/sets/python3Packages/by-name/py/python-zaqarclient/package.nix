{
  lib,
  buildPythonPackage,
  ddt,
  fetchFromGitHub,
  jsonschema,
  keystoneauth1,
  openstackdocstheme,
  osc-lib,
  oslo-i18n,
  oslo-log,
  oslo-utils,
  pbr,
  requests-mock,
  requests,
  setuptools,
  sphinxHook,
  stestrCheckHook,
  stevedore,
  websocket-client,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-zaqarclient";
  version = "4.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "python-zaqarclient";
    tag = finalAttrs.version;
    hash = "sha256-atUQs3helpHj+j1q1fNCgSGED5bbi/d41lIJUWlSLkg=";
  };

  # Manually set version since pbr wants to get it from git (not in a tarball)
  env.PBR_VERSION = finalAttrs.version;

  build-system = [
    pbr
    setuptools
  ];

  nativeBuildInputs = [
    openstackdocstheme
    sphinxHook
  ];

  sphinxBuilders = [ "man" ];

  dependencies = [
    jsonschema
    keystoneauth1
    osc-lib
    oslo-i18n
    oslo-log
    oslo-utils
    requests
    stevedore
  ];

  optional-dependencies = {
    websocket = [ websocket-client ];
  };

  nativeCheckInputs = [
    ddt
    requests-mock
    stestrCheckHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.websocket;

  pythonImportsCheck = [ "zaqarclient" ];

  meta = {
    homepage = "https://github.com/openstack/python-zaqarclient";
    description = "Client library for OpenStack Zaqar API";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
})
