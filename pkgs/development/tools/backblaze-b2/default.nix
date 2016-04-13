{ fetchFromGitHub, makeWrapper, pythonPackages, stdenv }:

pythonPackages.buildPythonApplication rec {
  name = "backblaze-b2-${version}";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "Backblaze";
    repo = "B2_Command_Line_Tool";
    rev = "74a5e567925899f1fc6204aa85d4c84c0d0e511a";
    sha256 = "1g9j5s69w6n70nb18rvx3gm9f4gi1vis23ib8rn2v1khv6z2acqp";
  };

  propagatedBuildInputs = with pythonPackages; [ six ];

  checkPhase = ''
    python test_b2_command_line.py test
  '';

  postInstall = ''
    mv "$out/bin/b2" "$out/bin/backblaze-b2"

    sed 's/^have b2 \&\&$/have backblaze-b2 \&\&/'   -i contrib/bash_completion/b2
    sed 's/^\(complete -F _b2\) b2/\1 backblaze-b2/' -i contrib/bash_completion/b2

    mkdir -p "$out/etc/bash_completion.d"
    cp contrib/bash_completion/b2 "$out/etc/bash_completion.d/backblaze-b2"
  '';

  meta = with stdenv.lib; {
    description = "Command-line tool for accessing the Backblaze B2 storage service";
    homepage = https://github.com/Backblaze/B2_Command_Line_Tool;
    license = licenses.mit;
    maintainers = with maintainers; [ hrdinka kevincox ];
    platforms = platforms.unix;
  };
}
