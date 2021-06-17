{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mastodon-archive";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "kensanata";
    repo = "mastodon-backup";
    rev = "v${version}";
    sha256 = "1dlrkygywxwm6xbn0pnfwd3f7641wnvxdyb5qihbsf62w1w08x8r";
  };

  propagatedBuildInputs = with python3.pkgs; [
    html2text
    mastodon-py
    progress
  ];

  # There is no test
  doCheck = false;

  meta = with lib; {
    description = "Utility for backing up your Mastodon content";
    homepage = "https://alexschroeder.ch/software/Mastodon_Archive";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ julm ];
  };
}
