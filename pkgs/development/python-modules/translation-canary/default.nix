{ lib
, buildPythonPackage
, fetchFromGitHub
, polib
, pocketlint
, python
, gettext
}:

buildPythonPackage rec {
  pname = "translation-canary";
  version = "2021";

  src = fetchFromGitHub {
    owner = "rhinstaller";
    repo = pname;
    rev = "d6a409851763464fad8276a25be2d9892a4bf83f";
    sha256 = "sha256-pvqCxutJ1cz19W66nihZaTbBAzEzsMdhe/OsqU9yUHE=";
  };

  preBuild = ''
    cat >setup.py <<'EOF'
    from setuptools import setup

    setup(
      name='translation_canary',
      packages=['translation_canary', 'translation_canary.translatable',
      'translation_canary.translated'],
      version='2021',
      #install_requires=install_requires,
    )
    EOF
  '';

  #doCheck = false;

  checkPhase = ''
    ${python.interpreter} -m unittest discover tests/unittests
  '';

  propagatedBuildInputs = [ polib pocketlint gettext ];
  checkInputs = [ gettext ];
  patches = [ ./test.patch ];

  meta = with lib; {
    homepage = "https://github.com/rhinstaller/translation-canary";
    description = "Translation sanity checker.";
    license = licenses.lgpl2Plus;
    maintainers = [ maintainers.govanify ];
  };

}
