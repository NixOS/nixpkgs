{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  humanfriendly,
  reretry,
  snakemake-interface-common,
  throttler,
  wrapt,
}:

buildPythonPackage rec {
  pname = "snakemake-interface-storage-plugins";
<<<<<<< HEAD
  version = "4.3.2";
=======
  version = "4.2.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = "snakemake-interface-storage-plugins";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-W2cUwc+9jng4IvBuN+m4WqpehA8qElTRb43w3QOIeN0=";
=======
    hash = "sha256-gez2UptlCorf42qHnnG31gfjzcTm9uyerF23N2fmTiM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    humanfriendly
    reretry
    snakemake-interface-common
    throttler
    wrapt
  ];

  pythonImportsCheck = [ "snakemake_interface_storage_plugins" ];

<<<<<<< HEAD
  meta = {
    description = "This package provides a stable interface for interactions between Snakemake and its storage plugins";
    homepage = "https://github.com/snakemake/snakemake-interface-storage-plugins";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ veprbl ];
=======
  meta = with lib; {
    description = "This package provides a stable interface for interactions between Snakemake and its storage plugins";
    homepage = "https://github.com/snakemake/snakemake-interface-storage-plugins";
    license = licenses.mit;
    maintainers = with maintainers; [ veprbl ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
