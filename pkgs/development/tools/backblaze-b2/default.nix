{ lib, buildPythonApplication, fetchFromGitHub
, arrow, futures, logfury, requests, six, tqdm
}:

buildPythonApplication rec {
  pname = "backblaze-b2";
  version = "1.3.6";

  src = fetchFromGitHub {
    owner = "Backblaze";
    repo = "B2_Command_Line_Tool";
    rev = "v${version}";
    sha256 = "12axb0c56razfhrx1l62sjvdrbg6vz0yyqph2mxyjza1ywpb93b5";
  };

  propagatedBuildInputs = [ arrow futures logfury requests six tqdm ];

  checkPhase = ''
    python test_b2_command_line.py test
  '';

  postPatch = ''
    # b2 uses an upper bound on arrow, because arrow 0.12.1 is not
    # compatible with Python 2.6:
    #
    # https://github.com/crsmithdev/arrow/issues/517
    #
    # However, since we use Python 2.7, newer versions of arrow are fine.

    sed -i 's/,<0.12.1//g' requirements.txt
  '';

  postInstall = ''
    mv "$out/bin/b2" "$out/bin/backblaze-b2"

    sed 's/^_have b2 \&\&$/_have backblaze-b2 \&\&/'  -i contrib/bash_completion/b2
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
