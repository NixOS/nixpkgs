{ lib, python3, fetchFromGitHub }:

let
  # csvs-to-sqlite is currently not compatible with Click 8. See the following
  # https://github.com/simonw/csvs-to-sqlite/issues/80
  #
  # Workaround the issue by providing click 7 explicitly.
  python = python3.override {
    packageOverrides = self: super: {
      # Use click 7
      click = super.click.overridePythonAttrs (old: rec {
        version = "7.1.2";
        src = old.src.override {
          inherit version;
          hash = "sha256-0rUlXHxjSbwb0eWeCM0SrLvWPOZJ8liHVXg6qU37axo=";
        };
      });
    };
  };
in with python.pkgs; buildPythonApplication rec {
  pname = "csvs-to-sqlite";
  version = "1.2";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = pname;
    rev = version;
    hash = "sha256-ZG7Yto8q9QNNJPB/LMwzucLfCGiqwBd3l0ePZs5jKV0";
  };

  propagatedBuildInputs = [
    click
    dateparser
    pandas
    py-lru-cache
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Convert CSV files into a SQLite database";
    homepage = "https://github.com/simonw/csvs-to-sqlite";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };

}
