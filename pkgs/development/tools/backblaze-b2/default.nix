{ fetchFromGitHub, makeWrapper, pythonPackages, stdenv }:

pythonPackages.buildPythonApplication rec {
  name = "backblaze-b2-${version}";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "Backblaze";
    repo = "B2_Command_Line_Tool";
    rev = "3a4cd3f0b5309f79f98c2e0d51afc19fb2fe4201";
    sha256 = "1gl1z7zg3s1xgx45i6b1bvx9iwviiiinl4my00h66qkhrw7ag8p1";
  };

  propagatedBuildInputs = with pythonPackages; [ futures requests six tqdm ];

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
