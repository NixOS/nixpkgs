{ lib
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "shell_gpt";
  version = "0.7.3";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "sha256-lS8zLtsh8Uz782KJwHqifEQnWQswbCXRVIfXWAmWtvI=";
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
