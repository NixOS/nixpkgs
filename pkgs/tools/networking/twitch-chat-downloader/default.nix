{ fetchFromGitHub
, lib
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "Twitch-Chat-Downloader";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "PetterKraabol";
    repo = "Twitch-Chat-Downloader";
    rev = version;
    sha256 = "1fh5h2nsn2lwkn8wkr3b9zxwwnd3arcqcf51h6lwcflgv4n39m1j";
  };

  propagatedBuildInputs = with python3Packages; [
    python-dateutil
    pytz
    requests
    twitch-python
  ];

  # Twitch-Chat-Download has no tests at all. Sanity check the command manually.
  checkPhase = ''
    "$out"/bin/tcd --help >/dev/null
  '';

  meta = with lib; {
    description = "Download chat messages from past broadcasts on Twitch";
    license = licenses.mit;
    homepage = "https://github.com/PetterKraabol/Twitch-Chat-Downloader";
    maintainers = with maintainers; [ strager ];
  };
}
