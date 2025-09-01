{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  setuptools,
  lxml,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "svgutils";
  version = "0.3.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "btel";
    repo = "svg_utils";
    tag = "v${version}";
    hash = "sha256-ITvZx+3HMbTyaRmCb7tR0LKqCxGjqDdV9/2taziUD0c=";
  };

  build-system = [ setuptools ];

  dependencies = [ lxml ];

  patches = [
    # Remove nose dependency, see: https://github.com/btel/svg_utils/pull/131

    # this first commit is required, as isort moved nose imports
    (fetchpatch2 {
      url = "https://github.com/btel/svg_utils/commit/48b078a729aeb6b1160142ab65157474c95a61b6.patch?full_index=1";
      hash = "sha256-9toOFfNkgGF3TvM340vYOTkuSEHBeiyBRSGqqobfiqI=";
    })

    # migrate to pytest
    (fetchpatch2 {
      url = "https://github.com/btel/svg_utils/commit/931a80220be7c0efa2fc6e1d47858d69a08df85e.patch?full_index=1";
      hash = "sha256-SMv0i8p3s57TDn6NM17RrHF9kVgsy2YJJ0KEBQKn2J0=";
    })
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "svgutils" ];

  meta = with lib; {
    description = "Python tools to create and manipulate SVG files";
    homepage = "https://github.com/btel/svg_utils";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
