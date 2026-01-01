{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  garth,
<<<<<<< HEAD
  importlib-resources,
  lxml,
  poetry-core,
  python-dotenv,
  requests,
=======
  lxml,
  python-dotenv,
  pythonOlder,
  requests,
  setuptools,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "withings-sync";
<<<<<<< HEAD
  version = "5.3.0";
  pyproject = true;

=======
  version = "4.2.7";
  pyproject = true;

  disabled = pythonOlder "3.10";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "jaroslawhartman";
    repo = "withings-sync";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Q9zOXQIdl4jpCK6a5Xp4kZK67MqudX0thDAkRmdL3AQ=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "1.0.0.dev1" "${version}"
  '';

  build-system = [ poetry-core ];

  dependencies = [
    garth
    importlib-resources
=======
    hash = "sha256-ySl2nRR8t7c3NhjgjSzLQ+hcJuh+kx5aoaVPJF56HR0=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "1.0.0.dev1" "${version}"
  '';

  pythonRelaxDeps = true;

  build-system = [ setuptools ];

  dependencies = [
    garth
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    lxml
    python-dotenv
    requests
  ];

  pythonImportsCheck = [ "withings_sync" ];

<<<<<<< HEAD
  meta = {
    description = "Synchronisation of Withings weight";
    homepage = "https://github.com/jaroslawhartman/withings-sync";
    changelog = "https://github.com/jaroslawhartman/withings-sync/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Synchronisation of Withings weight";
    homepage = "https://github.com/jaroslawhartman/withings-sync";
    changelog = "https://github.com/jaroslawhartman/withings-sync/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "withings-sync";
  };
}
