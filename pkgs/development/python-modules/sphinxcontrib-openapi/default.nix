{ lib
, buildPythonPackage
, deepmerge
, fetchFromGitHub
, fetchpatch
, isPy27
, setuptools-scm
, jsonschema
, picobox
, pyyaml
, sphinx-mdinclude
, sphinxcontrib_httpdomain
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-openapi";
  version = "unstable-2022-08-26";
  disabled = isPy27;

  # Switch to Cilums' fork of openapi, which uses m2r instead of mdinclude,
  # as m2r is unmaintained and incompatible with the version of mistune.
  # See
  # https://github.com/cilium/cilium/commit/b9862461568dd41d4dc8924711d4cc363907270b and
  # https://github.com/cilium/openapi/commit/cd829a05caebd90b31e325d4c9c2714b459d135f
  # for details.
  # PR to switch upstream sphinx-contrib/openapi from m2r to sphinx-mdinclude:
  # https://github.com/sphinx-contrib/openapi/pull/127
  # (once merged, we should switch away from that fork again)
  src = fetchFromGitHub {
    owner = "cilium";
    repo = "openapi";
    rev = "0ea3332fa6482114f1a8248a32a1eacb61aebb69";
    hash = "sha256-a/oVMg9gGTD+NClfpC2SpjbY/mIcZEVLLOR0muAg5zY=";
  };

  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [
    deepmerge
    jsonschema
    picobox
    pyyaml
    sphinx-mdinclude
    sphinxcontrib_httpdomain
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/ikalnytskyi/sphinxcontrib-openapi";
    description = "OpenAPI (fka Swagger) spec renderer for Sphinx";
    license = licenses.bsd0;
    maintainers = [ maintainers.flokli ];
  };
}
