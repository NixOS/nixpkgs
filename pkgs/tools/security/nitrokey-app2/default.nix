{ lib
, python3
, fetchPypi
, rustPlatform
, fetchFromGitHub
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      # https://github.com/nxp-mcuxpresso/spsdk/issues/64
      cryptography = super.cryptography.overridePythonAttrs (old: rec {
        version = "41.0.7";
        src = fetchPypi {
          inherit (old) pname;
          inherit version;
          hash = "sha256-E/k86b6oAWwlOzSvxr1qdZk+XEBnLtVAWpyDLw1KALw=";
        };
        cargoDeps = rustPlatform.fetchCargoTarball {
          inherit src;
          sourceRoot = "${old.pname}-${version}/${old.cargoRoot}";
          name = "${old.pname}-${version}";
          hash = "sha256-VeZhKisCPDRvmSjGNwCgJJeVj65BZ0Ge+yvXbZw86Rw=";
        };
        patches = [ ];
        doCheck = false; # would require overriding cryptography-vectors
      });
    };
  };
in python.pkgs.buildPythonApplication rec {
  pname = "nitrokey-app2";
  version = "2.1.5";
  pyproject = true;

  disabled = python.pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Nitrokey";
    repo = "nitrokey-app2";
    rev = "v${version}";
    hash = "sha256-mR13zUgCdNS09EnpGLrnOnoIn3p6ZM/0fHKg0OUMWj4=";
  };

  # https://github.com/Nitrokey/nitrokey-app2/issues/152
  #
  # pythonRelaxDepsHook does not work here, because it runs in postBuild and
  # only modifies the dependencies in the built distribution.
  postPatch = ''
    substituteInPlace pyproject.toml --replace 'pynitrokey = "' 'pynitrokey = ">='
  '';

  nativeBuildInputs = with python.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python.pkgs; [
    pynitrokey
    pyudev
    pyside6
    qt-material
  ];

  pythonImportsCheck = [
    "nitrokeyapp"
  ];

  meta = with lib; {
    description = "This application allows to manage Nitrokey 3 devices";
    homepage = "https://github.com/Nitrokey/nitrokey-app2";
    changelog = "https://github.com/Nitrokey/nitrokey-app2/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ _999eagle panicgh ];
    mainProgram = "nitrokeyapp";
  };
}
