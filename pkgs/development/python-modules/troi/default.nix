{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  click,
  lb-matching-tools,
  liblistenbrainz,
  more-itertools,
  mutagen,
  peewee,
  psycopg2-binary,
  py-sonic,
  python-dateutil,
  regex,
  requests,
  scikit-learn,
  spotipy,
  tqdm,
  ujson,
  unidecode,
  pytestCheckHook,
  requests-mock,
}:

buildPythonPackage rec {
  pname = "troi";
  version = "2025.08.06.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "metabrainz";
    repo = "troi-recommendation-playground";
    tag = "v${version}";
    hash = "sha256-qLnXaNb1Kon+XPJYCPe31EgXpukIfzTa+LADOzFjE9Q=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonRelaxDeps = [ "mutagen" ];
  pythonRemoveDeps = [
    # It's not used anywhere in the code.
    # TODO: Remove in next update. See <https://github.com/metabrainz/troi-recommendation-playground/pull/179>
    "countryinfo"
  ];

  dependencies = [
    click
    lb-matching-tools
    liblistenbrainz
    more-itertools
    mutagen
    peewee
    psycopg2-binary
    py-sonic
    python-dateutil
    regex
    requests
    scikit-learn
    spotipy
    tqdm
    ujson
    unidecode
  ];

  optional-dependencies = {
    # Not packaged yet.
    # nmslib = [ "nmslib-metabrainz" ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "troi" ];

  meta = {
    description = "ListenBrainz' empathic music recommendation/playlisting engine";
    homepage = "https://github.com/metabrainz/troi-recommendation-playground";
    changelog = "https://github.com/metabrainz/troi-recommendation-playground/releases/tag/${src.tag}";
    license = lib.licenses.gpl2Only;
    teams = [ lib.teams.ngi ];
  };
}
