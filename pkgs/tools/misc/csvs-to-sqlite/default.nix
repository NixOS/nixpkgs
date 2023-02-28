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
          sha256 = "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a";
        };
      });
    };
  };
in with python.pkgs; buildPythonApplication rec {
  pname = "csvs-to-sqlite";
  version = "1.2";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = pname;
    rev = version;
    sha256 = "0p99cg76d3s7jxvigh5ad04dzhmr6g62qzzh4i6h7x9aiyvdhvk4";
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
