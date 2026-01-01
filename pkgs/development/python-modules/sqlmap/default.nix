{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  file,
  setuptools,
}:

buildPythonPackage rec {
  pname = "sqlmap";
<<<<<<< HEAD
  version = "1.9.12";
=======
  version = "1.9.11";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-Cz83zLjGqvDjwVFmMi4AHB8JYbxgHkQnKHXVwyxEp1c=";
=======
    hash = "sha256-On76bRCiC7GEh5sdtTQnmohzkn7lvr4f1o9C25y/VJM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch = ''
    substituteInPlace sqlmap/thirdparty/magic/magic.py --replace "ctypes.util.find_library('magic')" \
      "'${file}/lib/libmagic${stdenv.hostPlatform.extensions.sharedLibrary}'"

    # the check for the last update date does not work in Nix,
    # since the timestamp of the all files in the nix store is reset to the unix epoch
    echo 'LAST_UPDATE_NAGGING_DAYS = float("inf")' >> sqlmap/lib/core/settings.py
  '';

  build-system = [ setuptools ];

  # No tests in archive
  doCheck = false;

  pythonImportsCheck = [ "sqlmap" ];

<<<<<<< HEAD
  meta = {
    description = "Automatic SQL injection and database takeover tool";
    homepage = "https://sqlmap.org";
    changelog = "https://github.com/sqlmapproject/sqlmap/releases/tag/${version}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ bennofs ];
=======
  meta = with lib; {
    description = "Automatic SQL injection and database takeover tool";
    homepage = "https://sqlmap.org";
    changelog = "https://github.com/sqlmapproject/sqlmap/releases/tag/${version}";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ bennofs ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "sqlmap";
  };
}
