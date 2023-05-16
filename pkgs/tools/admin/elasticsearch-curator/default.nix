<<<<<<< HEAD
{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "elasticsearch-curator";
  version = "8.0.8";
  format = "pyproject";
=======
{ lib, fetchFromGitHub, python3 }:

let
  python = python3.override {
    packageOverrides = self: super: {
      click = super.click.overridePythonAttrs (old: rec {
        version = "7.1.2";
        src = old.src.override {
          inherit version;
          hash = "sha256-0rUlXHxjSbwb0eWeCM0SrLvWPOZJ8liHVXg6qU37axo=";
        };
      });
      requests-aws4auth = super.requests-aws4auth.overridePythonAttrs (old: {
        doCheck = false; # requires click>=8.0
      });
    };
  };
in python.pkgs.buildPythonApplication rec {
  pname   = "elasticsearch-curator";
  version = "5.8.4";

  format = "setuptools";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "elastic";
    repo = "curator";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-G8wKeEr7TuUWlqz9hJmnJW7yxn+4WPoStVC0AX5jdHI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "elasticsearch8==" "elasticsearch8>=" \
      --replace "es_client==" "es_client>=" \
      --replace "ecs-logging==" "ecs-logging>=" \
      --replace "click==" "click>="\
      --replace "pyyaml==" "pyyaml>="
  '';

  nativeBuildInputs = with python3.pkgs; [
    hatchling
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
=======
    rev = "v${version}";
    hash = "sha256-wSfd52jebUkgF5xhjcoUjI7j46eJF33pVb4Wrybq44g=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "urllib3==1.26.4" "urllib3"
    substituteInPlace setup.py \
      --replace "urllib3==1.26.4" "urllib3" \
      --replace "pyyaml==5.4.1" "pyyaml"
  '';

  propagatedBuildInputs = with python.pkgs; [
    elasticsearch
    urllib3
    requests
    boto3
    requests-aws4auth
    click
    pyyaml
    voluptuous
    certifi
    six
  ];

  nativeCheckInputs = with python.pkgs; [
    mock
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pytestCheckHook
  ];

  disabledTestPaths = [
<<<<<<< HEAD
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
=======
    "test/integration" # requires running elasticsearch
  ];

  disabledTests = [
    # access network
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    "test_api_key_not_set"
    "test_api_key_set"
  ];

  meta = with lib; {
<<<<<<< HEAD
    description = "Curate, or manage, your Elasticsearch indices and snapshots";
    homepage = "https://github.com/elastic/curator";
    changelog = "https://github.com/elastic/curator/releases/tag/v${version}";
=======
    homepage = "https://github.com/elastic/curator";
    description = "Curate, or manage, your Elasticsearch indices and snapshots";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    maintainers = with maintainers; [ basvandijk ];
  };
}
