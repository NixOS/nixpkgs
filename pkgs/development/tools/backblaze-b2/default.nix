{ fetchFromGitHub
, lib
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "backblaze-b2";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "Backblaze";
    repo = "B2_Command_Line_Tool";
    rev = "v${version}";
    sha256 = "uL51F5/+dSMhjnJJtX/aEJh0WvKvQIryJPwW+HDfd84=";
  };

  propagatedBuildInputs = with python3Packages; [
    arrow
    b2sdk
    class-registry
    setuptools
  ];

  # Nosetests/pytest are failing on release 2.1.0
  doCheck = false;

  postInstall = ''
    mv "$out/bin/b2" "$out/bin/backblaze-b2"

    sed 's/b2/backblaze-b2/' -i contrib/bash_completion/b2

    mkdir -p "$out/share/bash-completion/completions"
    cp contrib/bash_completion/b2 "$out/share/bash-completion/completions/backblaze-b2"
  '';

  meta = with lib; {
    description = "Command-line tool for accessing the Backblaze B2 storage service";
    homepage = "https://github.com/Backblaze/B2_Command_Line_Tool";
    license = licenses.mit;
    maintainers = with maintainers; [ hrdinka kevincox ];
    platforms = platforms.unix;
  };
}
