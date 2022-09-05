{ lib, fetchFromGitHub, python3 }:

let
  python = python3.override {
    packageOverrides = self: super: {
      click = super.click.overridePythonAttrs (old: rec {
        version = "7.1.2";
        src = old.src.override {
          inherit version;
          sha256 = "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a";
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

  src = fetchFromGitHub {
    owner = "elastic";
    repo = "curator";
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

  checkInputs = with python.pkgs; [
    mock
    pytestCheckHook
  ];

  disabledTestPaths = [
    "test/integration" # requires running elasticsearch
  ];

  disabledTests = [
    # access network
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
    maintainers = with maintainers; [ basvandijk ];
  };
}
