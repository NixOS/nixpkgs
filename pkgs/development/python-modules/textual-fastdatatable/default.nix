{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  pyarrow,
  pytz,
  textual,
  tzdata,
  polars,
}:

buildPythonPackage rec {
  pname = "textual-fastdatatable";
  version = "0.10.0";
  pyproject = true;

  src = fetchPypi {
    pname = "textual_fastdatatable";
    inherit version;
    hash = "sha256-45uLpUzBb+xH+a+DIFiXB4YjabyFE4wmv1Tw3JtpNow=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    pyarrow
    pytz
    textual
    tzdata
  ];

  optional-dependencies = {
    polars = [
      polars
    ];
  };

  pythonImportsCheck = [
    "textual_fastdatatable"
  ];

  meta = {
    description = "A performance-focused reimplementation of Textual's DataTable widget, with a pluggable data storage backend";
    homepage = "https://pypi.org/project/textual-fastdatatable/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pcboy ];
  };
}
