{ lib
, fetchFromGitHub
, fetchpatch
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "rich-cli";
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Textualize";
    repo = "rich-cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-mV5b/J9wX9niiYtlmAUouaAm9mY2zTtDmex7FNWcezQ=";
  };

  patches = [
    # Update dependencies, https://github.com/Textualize/rich-cli/pull/94
    (fetchpatch {
      name = "update-dependencies.patch";
      url = "https://github.com/Textualize/rich-cli/pull/94/commits/1e9a11af7c1c78a5a44a207b1e0dce4c4b3c39f0.patch";
      hash = "sha256-cU+s/LK2GDVWXLZob0n5J6sLjflCr8w10hRLgeWN5Vg=";
    })
    (fetchpatch {
      name = "markdown.patch";
      url = "https://github.com/Textualize/rich-cli/pull/94/commits/0a8e77d724ace88ce88ee9d68a46b1dc8464fe0b.patch";
      hash = "sha256-KXvRG36Qj5kCj1RiAJsNkoJY7t41zUfJFgHeCtc0O4w=";
    })
  ];

  pythonRelaxDeps = [
    "textual"
  ];

  build-system = with python3.pkgs; [
    poetry-core
  ];

  nativeBuildInputs = with python3.pkgs; [
  ];

  dependencies = with python3.pkgs; [
    click
    requests
    rich
    rich-rst
    textual
  ];

  pythonImportsCheck = [
    "rich_cli"
  ];

  meta = with lib; {
    description = "Command Line Interface to Rich";
    homepage = "https://github.com/Textualize/rich-cli";
    changelog = "https://github.com/Textualize/rich-cli/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "rich";
  };
}
