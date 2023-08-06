{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "elasticsearch-curator";
  version = "8.0.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "elastic";
    repo = "curator";
    rev = "refs/tags/v${version}";
    hash = "sha256-FPp2BpfYsmNwwevYQ6EH3N1q0TjyeEsBeDM9EUbLl+Q=";
  };

  pythonRelaxDeps = [
    "click"
    "ecs-logging"
    "elasticsearch8"
    "es_client"
    "pyyaml"
  ];

  nativeBuildInputs = with python3.pkgs; [
    hatchling
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    certifi
    click
    ecs-logging
    elasticsearch8
    es-client
    pyyaml
    six
    voluptuous
  ];

  nativeCheckInputs = with python3.pkgs; [
    mock
    requests
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Test requires running elasticsearch
    "tests/integration/test_alias.py"
    "tests/integration/test_allocation.py"
    "tests/integration/test_cli.py"
    "tests/integration/test_close.py"
    "tests/integration/test_clusterrouting.py"
    "tests/integration/test_count_pattern.py"
    "tests/integration/test_create_index.py"
    "tests/integration/test_datemath.py"
    "tests/integration/test_delete_indices.py"
    "tests/integration/test_delete_snapshots.py"
    "tests/integration/test_delete_snapshots.py"
    "tests/integration/test_es_repo_mgr.py"
    "tests/integration/test_forcemerge.py"
    "tests/integration/test_integrations.py"
    "tests/integration/test_open.py"
    "tests/integration/test_reindex.py"
    "tests/integration/test_replicas.py"
    "tests/integration/test_restore.py"
    "tests/integration/test_rollover.py"
    "tests/integration/test_shrink.py"
    "tests/integration/test_snapshot.py"
  ];

  disabledTests = [
    # Test require access network
    "test_api_key_not_set"
    "test_api_key_set"
  ];

  meta = with lib; {
    homepage = "https://github.com/elastic/curator";
    description = "Curate, or manage, your Elasticsearch indices and snapshots";
    license = licenses.asl20;
    longDescription = ''
      Elasticsearch Curator helps you curate, or manage, your Elasticsearch
      indices and snapshots by:

      * Obtaining the full list of indices (or snapshots) from the cluster, as the
        actionable list

      * Iterate through a list of user-defined filters to progressively remove
        indices (or snapshots) from this actionable list as needed.

      * Perform various actions on the items which remain in the actionable list.
    '';
    changelog = "https://github.com/elastic/curator/releases/tag/v${version}";
    maintainers = with maintainers; [ basvandijk ];
  };
}
