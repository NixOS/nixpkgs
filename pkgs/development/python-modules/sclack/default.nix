{ stdenv
, fetchFromGitHub
, pythonOlder
, pythonPackages
, buildPythonPackage
, writeTextFile
, libcaca
, glibcLocales
, pytestCheckHook
}:
buildPythonPackage rec {
  pname = "sclack";
  version = "unstable-2019-07-15";

  # slackclient 2.0 requires python 3.6 or higher -- https://github.com/slackapi/python-slackclient/wiki/Migrating-to-2.x#minimum-python-versions
  disabled = pythonOlder "3.6";

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

  LC_ALL = "en_US.UTF-8";
  checkInputs = [ glibcLocales pytestCheckHook ];

  # disable tests that prompt for user input and require network access
  disabledTests = [
    "test_workspace_token"
    "test_auth"
    "test_get_channels"
    "test_get_members"
    "test_get_members_pagination_1"
    "test_get_members_pagination_2"
  ];

  prePatch = ''
    # remove the dependency on asyncio from setup.py
    # asyncio is included with python3.7+
    substituteInPlace setup.py \
      --replace  "'asyncio'," ' '

    # slackclient renamed several major components in 2.x
    # see the Migration Guide for more information -- https://github.com/slackapi/python-slackclient/wiki/Migrating-to-2.x#import-changes
    for file in {sclack/store,tests/test_api}.py; do
      substituteInPlace $file \
      --replace 'slackclient' 'slack' \
      --replace 'SlackClient' 'WebClient'
    done
  '';

  postInstall = ''
    mkdir $out/share
    # make the relative path for config.json absolute
    substituteInPlace app.py --replace "'./config.json'" "'$out/share/config.json'"
    cp config.json $out/share/
    
    install -m755 app.py $out/bin/sclack
  '';


  meta = with stdenv.lib; {
    description = "The best CLI client for Slack, because everything is terrible!";
    license = licenses.gpl3;
    platforms = platforms.all;
    homepage = https://github.com/haskellcamargo/sclack/;
    maintainers = with maintainers; [ evanjs ];
  };
}
