{ lib
, stdenv
, python3
, fetchPypi
, fetchFromGitHub
, wrapQtAppsHook
, qtbase
, qtwayland
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      pynitrokey = super.pynitrokey.overridePythonAttrs (old: rec {
        version = "0.4.45";
        src = fetchPypi {
          inherit (old) pname;
          inherit version;
          hash = "sha256-iY4ThrmXP7pEjTYYU4lePVAbuJGTdHX3iKswXzuf7W8=";
        };
      });
    };
  };
in python.pkgs.buildPythonApplication rec {
  pname = "nitrokey-app2";
  version = "2.2.2";
  pyproject = true;

  disabled = python.pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Nitrokey";
    repo = "nitrokey-app2";
    rev = "v${version}";
    hash = "sha256-MiyfmsrKZRoe7YMEjR1LHPesfJh6+dcSydoEAgrALJ8=";
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
    wrapQtAppsHook
  ];

  buildInputs = [ qtbase ] ++ lib.optionals stdenv.isLinux [
    qtwayland
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
