{
  lib,
  buildPythonPackage,
  fetchPypi,

  pythonOlder,

  poetry-core,
}:

buildPythonPackage rec {
  pname = "spylls";
  version = "0.1.7";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cEWJLcvTJNNoX2nFp2AGPnj7g5kTckzhgHfPCgyT8iA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
    --replace-fail poetry.masonry.api poetry.core.masonry.api \
    --replace-fail "poetry>=" "poetry-core>="
  '';

  build-system = [ poetry-core ];

  # no unit tests in source distribution...
  doCheck = false;

  pythonImportsCheck = [
    "spylls.hunspell"
    "spylls.hunspell.readers"
    "spylls.hunspell.data"
    "spylls.hunspell.algo.capitalization"
    "spylls.hunspell.algo.trie"
    "spylls.hunspell.algo.ngram_suggest"
    "spylls.hunspell.algo.phonet_suggest"
    "spylls.hunspell.algo.permutations"
    "spylls.hunspell.algo.string_metrics"
  ];

  meta = with lib; {
    description = "Pure Python spell-checker, (almost) full port of Hunspell";
    homepage = "https://github.com/zverok/spylls";
    changelog = "https://github.com/zverok/spylls/blob/master/CHANGELOG.rst";
    license = licenses.mpl20;
    maintainers = with maintainers; [ vizid ];
  };
}
