{ lib
, fetchFromGitHub
, python3
}:

let
  py = python3.override {
    packageOverrides = final: prev: {
      rich = prev.rich.overridePythonAttrs (old: rec {
        version = "12.4.0";
        src = fetchFromGitHub {
          owner = "Textualize";
          repo = "rich";
          rev = "refs/tags/v12.4.0";
          hash = "sha256-ryJTusUNpvNF2031ICJWK8ScxHIh+LrXYg7nd0ph4aQ=";
        };
        propagatedBuildInputs = with py.pkgs; [
          commonmark
          pygments
        ];
        doCheck = false;
      });

      textual = prev.textual.overridePythonAttrs (old: rec {
        version = "0.1.18";
        src = fetchFromGitHub {
          owner = "Textualize";
          repo = "textual";
          rev = "refs/tags/v0.1.18";
          hash = "sha256-XVmbt8r5HL8r64ISdJozmM+9HuyvqbpdejWICzFnfiw=";
        };
        doCheck = false;
      });
    };
  };
in

python3.pkgs.buildPythonApplication rec {
  pname = "rich-cli";
  version = "1.8.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Textualize";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-mV5b/J9wX9niiYtlmAUouaAm9mY2zTtDmex7FNWcezQ=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'rich = "^12.4.0"' 'rich = "*"' \
      --replace 'textual = "^0.1.18"' 'textual = "*"'
  '';

  nativeBuildInputs = with py.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with py.pkgs; [
    rich
    click
    requests
    textual
    rich-rst
  ];

  pythonImportsCheck = [
    "rich_cli"
  ];

  meta = with lib; {
    description = "Command Line Interface to Rich";
    homepage = "https://github.com/Textualize/rich-cli";
    changelog = "https://github.com/Textualize/rich-cli/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ joelkoen ];
  };
}
