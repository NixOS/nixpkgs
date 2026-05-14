{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  pythonAtLeast,
  argcomplete,
  requests,
  setuptools,
  looseversion,
  gnupg,
}:

buildPythonPackage rec {
  pname = "sdkmanager";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "fdroid";
    repo = "sdkmanager";
    tag = version;
    hash = "sha256-/MrRCR6TJ64DiL4D1290jik1L+jITi4dH9Tj3cjF+ms=";
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
