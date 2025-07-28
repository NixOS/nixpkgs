{
  lib,
  python3,
  fetchPypi,
  nixosTests,
}:

with python3.pkgs;

buildPythonPackage rec {
  pname = "postorius";
  version = "1.3.10";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GmbIqO+03LgbUxJ1nTStXrYN3t2MfvzbeYRAipfTW1o=";
  };

  propagatedBuildInputs = [
    django-mailman3
    readme-renderer
  ]
  ++ readme-renderer.optional-dependencies.md;
  nativeCheckInputs = [
    beautifulsoup4
    vcrpy
    mock
  ];

  # Tries to connect to database.
  doCheck = false;

  passthru.tests = { inherit (nixosTests) mailman; };

  meta = with lib; {
    homepage = "https://docs.mailman3.org/projects/postorius";
    description = "Web-based user interface for managing GNU Mailman";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ qyliss ];
  };
}
