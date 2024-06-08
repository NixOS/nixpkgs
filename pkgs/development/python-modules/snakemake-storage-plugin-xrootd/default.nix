{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  snakemake,
  snakemake-interface-storage-plugins,
  snakemake-interface-common,
  xrootd,
}:

buildPythonPackage rec {
  pname = "snakemake-storage-plugin-xrootd";
  version = "unstable-2023-12-16";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = pname;
    rev = "408f1e956b5427c34b49eeca340492a438e8eccb";
    hash = "sha256-CcSG//D9kz0Q4LtaSngJpCtY0dbNFFuKMVmBxR1fcMo=";
  };

  # xrootd<6.0.0,>=5.6.4 not satisfied by version 5.7rc20240303
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'xrootd = "^5.6.4"' ""
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    snakemake-interface-storage-plugins
    snakemake-interface-common
    xrootd
  ];

  nativeCheckInputs = [ snakemake ];

  pythonImportsCheck = [ "snakemake_storage_plugin_xrootd" ];

  meta = with lib; {
    description = "A Snakemake storage plugin for handling input and output via XRootD";
    homepage = "https://github.com/snakemake/snakemake-storage-plugin-xrootd";
    license = licenses.mit;
    maintainers = with maintainers; [ veprbl ];
  };
}
