{
  fetchFromGitHub,
  lib,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "backblaze-b2";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "Backblaze";
    repo = "B2_Command_Line_Tool";
    rev = "v${version}";
    sha256 = "00zs0a580vvfm2w4ja68mc46360p475wlgagjkq1hi4m8s4qwd75";
  };

  propagatedBuildInputs = with python3Packages; [
    b2sdk
    class-registry
    setuptools
  ];

  checkInputs = with python3Packages; [
    nose
  ];

  # doCheck = false;
  checkPhase = ''
    nosetests
  '';

  postInstall = ''
    mv "$out/bin/b2" "$out/bin/backblaze-b2"

    sed 's/b2/backblaze-b2/' -i contrib/bash_completion/b2

    mkdir -p "$out/etc/bash_completion.d"
    cp contrib/bash_completion/b2 "$out/etc/bash_completion.d/backblaze-b2"
  '';

  meta = with lib; {
    description = "Command-line tool for accessing the Backblaze B2 storage service";
    homepage = "https://github.com/Backblaze/B2_Command_Line_Tool";
    license = licenses.mit;
    maintainers = with maintainers; [ hrdinka kevincox ];
    platforms = platforms.unix;
  };
}
