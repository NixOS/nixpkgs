{ lib
, python3
, nix-update-script
}:

python3.pkgs.buildPythonApplication rec {
  pname = "shell_gpt";
  version = "0.8.8";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "sha256-KuaSAiXlqWRhFtX4C6vibbUiq43L83pZX+yM9L7Ej68=";
  };

  nativeBuildInputs = with python3.pkgs; [
    python3.pkgs.pythonRelaxDepsHook
    python3
    pip
  ];

  propagatedBuildInputs = with python3.pkgs; [
    markdown-it-py
    rich
    distro
    typer
    requests
  ];

  pythonRelaxDeps = [ "requests" "rich" "distro" "typer" ];

  passthru.updateScript = nix-update-script { };

  doCheck = false;

  meta = with lib; {
    mainProgram = "sgpt";
    homepage = "https://github.com/TheR1D/shell_gpt";
    description = "Access ChatGPT from your terminal";
    platforms = platforms.unix;
    license = licenses.mit;
    maintainers = with maintainers; [ mglolenstine ];
  };
}
