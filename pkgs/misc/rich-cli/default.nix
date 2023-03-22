{ lib
, fetchFromGitHub
, python3
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      rich = super.rich.overrideAttrs (old: rec {
        version = "12.4.0";
        src = fetchFromGitHub {
          owner = "Textualize";
          repo = "rich";
          rev = "refs/tags/v${version}";
          hash = "sha256-ryJTusUNpvNF2031ICJWK8ScxHIh+LrXYg7nd0ph4aQ=";
        };
      });
      textual = super.textual.overrideAttrs (old: rec {
        version = "0.1.18";
        src = fetchFromGitHub {
          owner = "Textualize";
          repo = "textual";
          rev = "refs/tags/v${version}";
          hash = "sha256-XVmbt8r5HL8r64ISdJozmM+9HuyvqbpdejWICzFnfiw=";
        };
      });
    };
  };
in

python.pkgs.buildPythonApplication rec {
  pname = "rich-cli";
  version = "1.8.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Textualize";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-mV5b/J9wX9niiYtlmAUouaAm9mY2zTtDmex7FNWcezQ=";
  };

  nativeBuildInputs = with python.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python.pkgs; [
    rich
    click
    requests
    textual
    rich-rst
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'rich = "^12.4.0"' 'rich = "*"' \
      --replace 'textual = "^0.1.18"' 'textual = "*"'
  '';

  pythonImportsCheck = [
    "rich_cli"
  ];

  meta = with lib; {
    description = "Command Line Interface to Rich";
    homepage = "https://github.com/Textualize/rich-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ joelkoen ];
  };
}
