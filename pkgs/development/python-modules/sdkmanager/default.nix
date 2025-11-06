{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  pythonOlder,
  pythonAtLeast,
  argcomplete,
  requests,
  setuptools,
  looseversion,
  gnupg,
}:

buildPythonPackage rec {
  pname = "sdkmanager";
  version = "0.6.11";
  pyproject = true;

  disabled = pythonOlder "3.5";

  src = fetchFromGitLab {
    owner = "fdroid";
    repo = "sdkmanager";
    tag = version;
    hash = "sha256-UBBko5copc5y9kdUr8jqJgijxRLfpRuJmT1QSow/eVg=";
  };

  pythonRelaxDeps = [ "urllib3" ];

  build-system = [ setuptools ];

  dependencies = [
    argcomplete
    requests
  ]
  ++ requests.optional-dependencies.socks
  ++ lib.optionals (pythonAtLeast "3.12") [ looseversion ];

  postInstall = ''
    wrapProgram $out/bin/sdkmanager \
      --suffix PATH : ${lib.makeBinPath [ gnupg ]}
  '';

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "sdkmanager" ];

  meta = {
    homepage = "https://gitlab.com/fdroid/sdkmanager";
    description = "Drop-in replacement for sdkmanager from the Android SDK written in Python";
    mainProgram = "sdkmanager";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ linsui ];
  };
}
