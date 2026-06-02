{
  lib,
  python3,
  fetchPypi,
  fetchpatch,
  nixosTests,
}:

with python3.pkgs;

buildPythonPackage (finalAttrs: {
  pname = "postorius";
  version = "1.3.10";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-GmbIqO+03LgbUxJ1nTStXrYN3t2MfvzbeYRAipfTW1o=";
  };

  patches = [
    (fetchpatch {
      name = "security-fix.patch";
      url = "https://gitlab.com/mailman/postorius/-/commit/c4706abd05ba6bcf472fc674b160d3a9d6a4868b.patch";
      excludes = [ "src/postorius/doc/news.rst" ];
      hash = "sha256-M8C7mO/KoVhl1YtZ5x3wqL+aBkepJ/7NoIRUmd0JpiM=";
    })
  ];

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

  meta = {
    homepage = "https://docs.mailman3.org/projects/postorius";
    description = "Web-based user interface for managing GNU Mailman";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ qyliss ];
  };
})
