{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  email-validator,
  h5py,
  lazy-loader,
  mpltoolbox,
  numpy,
  plopp,
  pydantic,
  python-dateutil,
  scipp,
  scippnexus,
  scipy,

  # tests
  pytestCheckHook,
  pooch,
  hypothesis,
  ipykernel,
  ipympl,
  psutil,
  pytest-xdist,
  pythreejs,
  sciline,
  stdenvNoCC,
  curl,
  cacert,
}:

buildPythonPackage (finalAttrs: {
  pname = "scippneutron";
  version = "26.6.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "scipp";
    repo = "scippneutron";
    tag = finalAttrs.version;
    hash = "sha256-ZhQVOUX2LcoLtAvAos7CWfVHKfqIWtIsXeYAPbUZTV0=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    email-validator
    h5py
    lazy-loader
    mpltoolbox
    numpy
    plopp
    pydantic
    python-dateutil
    scipp
    scippnexus
    scipy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
    ipykernel
    ipympl
    pooch
    psutil
    pytest-xdist
    pythreejs
    sciline
  ];

  env = {
    # See: https://github.com/scipp/scippneutron/blob/26.6.0/src/scippneutron/data/__init__.py
    SCIPPNEUTRON_DATA_DIR =
      let
        # NOTE this might be changed by upstream in the future.
        _version = "5";
      in
      stdenvNoCC.mkDerivation {
        name = "plopp-test-data";
        dontUnpack = true;
        strictDeps = true;
        __structuredAttrs = true;
        nativeBuildInputs = [
          curl
        ];
        configurePhase = ''
          curlVersion=$(curl -V | head -1 | cut -d' ' -f2)
          curl=(
              curl
              --location
              --max-redirs 20
              --retry 3
              --retry-all-errors
              --continue-at -
              --disable-epsv
              --cookie-jar cookies
              --user-agent "curl/$curlVersion Nixpkgs"
          )
          export SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt"
          mkdir -p $out/${_version}
        '';
        buildPhase =
          lib.pipe
            [
              "iris26176_graphite002_sqw.nxs"
              "loki-at-larmor.hdf5"
              "loki-at-larmor-filtered.hdf5"
              "powder-event.h5"
              "powder-event-filtered.h5"
              "mcstas_sans.h5"
              "CNCS_51936_event.nxs"
              "GEM40979.raw"
              "PG3_4844_calibration.h5"
              "PG3_4844_event.nxs"
              "PG3_4866_event.nxs"
              "PG3_4871_event.nxs"
              "WISH00016748.raw"
              "horace_sqw_4d.sqw"
              "dream_geant4_data.h5"
            ]
            [
              (map (
                f:
                "curl \"https://public.esss.dk/groups/scipp/scippneutron/${_version}/${f}\" --output \"$out/${_version}/${f}\""
              ))
              (lib.concatStringsSep "\n")
            ];
        dontInstall = true;
        dontFixup = true;
        outputHash = "sha256-UxFphegP2VdQ7zMssAf8FQbrQqOr4+qVjcIugxz0ZxA=";
        outputHashMode = "recursive";
      };
  };

  # See <https://github.com/scipp/scippneutron/issues/710>. From some reason
  # the whole file has to be deleted, otherwise the tests are not disabled.
  preCheck = ''
    rm tests/masking_tool_test.py
  '';

  pythonImportsCheck = [
    "scippneutron"
  ];

  meta = {
    description = "Neutron scattering toolkit built using scipp for Data Reduction. Not facility or instrument specific";
    homepage = "https://scipp.github.io/scippneutron";
    changelog = "https://github.com/scipp/scippneutron/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
})
