{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python-dateutil,
  poetry-core,
  requests,
  isodate,
  ratelimit,
  typing-extensions,
  mpegdash,
  pyaes,
}:
buildPythonPackage rec {
  pname = "tidalapi";
<<<<<<< HEAD
  version = "0.8.10";
=======
  version = "0.8.8";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "EbbLabs";
    repo = "python-tidal";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-hqtTe/KIGds01udMKoH5xXnoEe17FuOXLvWtp1yvJ2c=";
=======
    hash = "sha256-+O+U8QZhaOdUgPONv1tb5ctiK8NmD2NJK0hokmNtUZM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    requests
    python-dateutil
    mpegdash
    isodate
    ratelimit
    typing-extensions
    pyaes
  ];

  doCheck = false; # tests require internet access

  pythonImportsCheck = [
    "tidalapi"
  ];

  meta = {
    changelog = "https://github.com/tamland/python-tidal/blob/v${version}/HISTORY.rst";
    description = "Unofficial Python API for TIDAL music streaming service";
    homepage = "https://github.com/tamland/python-tidal";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      drafolin
      drawbu
      ryand56
    ];
  };
}
