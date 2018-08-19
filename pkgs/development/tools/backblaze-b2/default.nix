{ lib, buildPythonApplication, fetchFromGitHub
, arrow, futures, logfury, requests, six, tqdm
}:

buildPythonApplication rec {
  pname = "backblaze-b2";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "Backblaze";
    repo = "B2_Command_Line_Tool";
    rev = "v${version}";
    sha256 = "0697rcdsmxz51p4b8m8klx2mf5xnx6vx56vcf5jmzidh8mc38a6z";
  };

  propagatedBuildInputs = [ arrow futures logfury requests six tqdm ];

  checkPhase = ''
    python test_b2_command_line.py test
  '';

  postInstall = ''
    mv "$out/bin/b2" "$out/bin/backblaze-b2"

    sed 's/^have b2 \&\&$/_have backblaze-b2 \&\&/'  -i contrib/bash_completion/b2
    sed 's/^\(complete -F _b2\) b2/\1 backblaze-b2/' -i contrib/bash_completion/b2

    mkdir -p "$out/etc/bash_completion.d"
    cp contrib/bash_completion/b2 "$out/etc/bash_completion.d/backblaze-b2"
  '';

  meta = with lib; {
    description = "Command-line tool for accessing the Backblaze B2 storage service";
    homepage = https://github.com/Backblaze/B2_Command_Line_Tool;
    license = licenses.mit;
    maintainers = with maintainers; [ hrdinka kevincox ];
    platforms = platforms.unix;
  };
}
