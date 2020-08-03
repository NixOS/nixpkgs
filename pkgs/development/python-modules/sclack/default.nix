{ stdenv
, fetchFromGitHub
, pythonOlder
, pythonPackages
, buildPythonPackage
, writeTextFile
, libcaca
}:
buildPythonPackage rec {
  pname = "sclack";
  version = "unstable-2019-07-15";
  disabled = pythonOlder "3.4";

  src = fetchFromGitHub {
    owner = "haskellcamargo";
    repo = "sclack";
    rev = "4825249f9706ded585ac0d42ac7d86262fa14fd7";
    sha256 = "1dc3s3jn2ig55d8955fnjyppjkaw92mrzwpkv2hd0r8v1mffavi6";
  };

  propagatedBuildInputs = with pythonPackages; [
    libcaca
    pyperclip
    requests
    slackclient
    urwid
    urwid_readline
  ];

  patchPhase = ''
    substituteInPlace app.py --replace "'./config.json'" "'$out/bin/config.json'"
    substituteInPlace setup.py --replace  "'asyncio'," ' '
  '';

  postInstall = ''
    mv $out/bin/app.py $out/bin/sclack
    cp config.json $out/bin/
  '';


  meta = with stdenv.lib; {
    description = "The best CLI client for Slack, because everything is terrible!";
    license = licenses.gpl3;
    platforms = platforms.all;
    homepage = https://github.com/haskellcamargo/sclack/;
    maintainers = with maintainers; [ evanjs ];
  };
}
