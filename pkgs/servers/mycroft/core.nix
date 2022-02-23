{ lib
, fetchFromGitHub

# runtime
, python3

}:

let
  pname = "mycroft-core";
  version = "21.2.2";

  python = python3.override {
    packageOverrides = self: super: {
      msm = super.msm.overridePythonAttrs (oldAttrs: rec {
        version = "0.8.9";
        src = fetchFromGitHub {
          owner = "MycroftAI";
          repo = "mycroft-skills-manager";
          rev = "release/v${version}";
          hash = "sha256-u6ueeRuJOu5fETlJDLCBACnYlbSsd9L1U32PK2YLw80=";
        };
      });

      websocket-client = super.websocket-client.overridePythonAttrs (oldAttrs: rec {
        version = "1.2.3";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "sha256-ExWBbArMUImX6zrgO50/9hnJ0S1UTJqbVTcEscxPavU=";
        };
      });
    };
  };
in
python.pkgs.buildPythonApplication {
  inherit pname version;
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "MycroftAI";
    repo = pname;
    rev = "release/v${version}";
    hash = "sha256-SCz4rQYTHB1wKeQnJwjmc/jJr/aOWB73tjBqCHjfIAs=";
  };

  postPatch = let
    relaxedConstraints = [
      "adapt-parser"
      "fann2"
      "fasteners"
      "inflection"
      "mycroft-messagebus-client"
      "padaos"
      "padatious"
      "pillow"
      "pocketsphinx"
      "precise-runner"
      "psutil"
      "pyee"
      "pyserial"
      "python-dateutil"
      "pyxdg"
      "PyYAML"
      "requests"
      "requests-futures"
      "websocket-client"
    ];
  in ''
    sed -r -i \
      ${lib.concatStringsSep "\n" (map (package:
        ''-e 's@${package}[<>~=]+.*@${package}@g' \''
      ) relaxedConstraints)}
    requirements/requirements.txt
  '';

  propagatedBuildInputs = with python.pkgs; [
    adapt-parser
    fann2
    fasteners
    gtts
    inflection
    lingua-franca
    msk
    msm
    mycroft-messagebus-client
    padaos
    padatious
    petact
    pillow
    pocketsphinx
    precise-runner
    psutil
    pyaudio
    PyChromecast
    pyee
    pyserial
    python-dateutil
    python-vlc
    pyxdg
    pyyaml
    requests
    requests-futures
    speechrecognition
    tornado
    websocket-client
  ];

  preCheck = ''
    # creates paths according to xdg spec
    export HOME=$TMPDIR
  '';

  checkInputs = with python.pkgs; [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    # AssertionError: 'ZZZZZZZZZ' != 'HH EY . M AY K R AO F T'
    # https://github.com/MycroftAI/mycroft-core/issues/2574
    "--deselect test/unittests/client/test_hotword_factory.py::PocketSphinxTest::testInvalid"

    # AssertionError: 'hey victoria' != 'hey mycroft'
    # https://github.com/MycroftAI/mycroft-core/issues/2574
    "--deselect test/unittests/client/test_local_recognizer.py::LocalRecognizerInitTest::testListenerConfig"

    # Requires network access
    "--deselect test/unittests/util/test_network_utils.py::TestNetworkConnected::test_default_config_succeeds"
    "--deselect test/unittests/util/test_network_utils.py::TestNetworkFailure::test_secondary_dns_succeeds"

    # Expects zoneinfo in /usr/share/zoneinfo
    "--deselect test/unittests/util/test_time.py::TestTimeFuncs::test_default_timezone"
    "--deselect test/unittests/util/test_time.py::TestTimeFuncs::test_now_local"
  ];

  disabledTests = [
    # mycroft.api.InternetDown
    "test_is_paired_error_remote"
  ];

  disabledTestPaths = [
    # breaks the tests by deleting /build/source
    "test/unittests/util/test_file_utils.py"
  ];

  meta = with lib; {
    description = "Mycroft Core, the Mycroft Artificial Intelligence platform";
    homepage = "https://github.com/MycroftAI/mycroft-core";
    license = licenses.asl20;
    maintainers = teams.mycroft.members;
    platforms = platforms.linux;
  };
}
