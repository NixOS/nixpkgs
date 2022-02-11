{ lib, fetchFromGitHub, python }:

let
py = python.override {
  packageOverrides = self: super: {
    click = super.click.overridePythonAttrs (oldAttrs: rec {
      version = "6.7";
      src = oldAttrs.src.override {
        inherit version;
        sha256 = "f15516df478d5a56180fbf80e68f206010e6d160fc39fa508b65e035fd75130b";
      };
      doCheck = false;
      postPatch = "";
    });
  };
};
in

with py.pkgs;
buildPythonApplication rec {
  pname   = "elasticsearch-curator";
  version = "5.8.1";

  src = fetchFromGitHub {
    owner = "elastic";
    repo = "curator";
    rev = "v${version}";
    sha256 = "1shr9jslirjnbvma3p19djsnamxl7f3m9c8zrlclk57zv8rnwpkr";
  };

  # The test hangs so we disable it.
  doCheck = false;

  propagatedBuildInputs = [
    click
    certifi
    requests-aws4auth
    pyopenssl
    voluptuous
    pyyaml
    elasticsearch
    boto3
  ];

  checkInputs = [
    nosexcover
    coverage
    nose
    mock
    funcsigs
  ];

  postPatch = ''
    sed -i s/pyyaml==3.13/pyyaml/g setup.cfg setup.py
    sed -i s/pyyaml==3.12/pyyaml/g setup.cfg setup.py
    substituteInPlace setup.py \
      --replace "urllib3>=1.24.2,<1.25" "urllib3"
    substituteInPlace setup.cfg \
      --replace "urllib3>=1.24.2,<1.25" "urllib3"
  '';

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

    # https://github.com/elastic/curator/pull/1280
    #broken = versionAtLeast click.version "7.0";
  };
}
