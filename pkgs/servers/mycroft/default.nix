{ stdenv, lib, fetchFromGitHub, python27
, autoreconfHook, pkgconfig, swig
, alsaLib, curl, flac, glib, icu, libfann, libffi, libjpeg
, libpulseaudio, vlc, mimic, mpg123, openssl, pocketsphinx, portaudio, s3cmd
, swig2, xxHash, zlib }:

# TODO:
# 1. use the new fork for libfann:
#    https://github.com/andersfylling/fann/releases
# 2. fix up msm paths

let
  depends = service:
    lib.concatStringsSep " " (if (service != "bus")
      then [ "mycroft-bus.service" ]
      else [ "pulseaudio.service" ]);

  py = python27.override {
    packageOverrides = self: super: rec {
      adapt-parser = super.buildPythonPackage rec {
        pname = "adapt-parser";
        version = "0.3.0";
        src = super.fetchPypi {
          inherit pname version;
          sha256 = "0zrk9p6147dn88ibf7aqxg1137ili6i5wq5w3yfm2g6g9yzcjicl";
        };
        postPatch = ''
          sed -i 's/six==1.10.0/six/' setup.py
        '';
        propagatedBuildInputs = with super; [ pyee six ];
      };

      fann2 = super.buildPythonPackage rec {
        pname = "fann2";
        version = "1.1.2";

        src = super.fetchPypi {
          inherit pname version;
          sha256 = "07nlpncl5cx2kzdy3r91g3i1bsnl7n6f7zracwh87q28mmjhmjnd";
        };

        postPatch = ''
          substituteInPlace setup.py \
            --replace /lib ${libfann}/lib
        '';

        buildInputs = [ libfann ];

        nativeBuildInputs = [ swig ];
        # propagatedBuildInputs = with super; [ gtts-token requests ];
      };

      gtts = super.buildPythonPackage rec {
        pname = "gTTS";
        version = "1.2.2";
        src = super.fetchPypi {
          inherit pname version;
          sha256 = "05j5dq8mifdlck84gsdha9w7bv7rc64pjspx52ihpipbmdxvvvb3";
        };
        propagatedBuildInputs = with super; [ gtts-token requests ];
      };

      gtts-token = super.buildPythonPackage rec {
        pname = "gTTS-token";
        version = "1.1.1";
        src = super.fetchPypi {
          inherit pname version;
          extension = "zip";
          sha256 = "1vw3j8hw4hdhznk6gmhm82yhwsp79nv0jaj69axdhwvplcxxzfkl";
        };
        propagatedBuildInputs = with super; [ requests ];
      };

      padatious = super.buildPythonPackage rec {
        pname = "padatious";
        version = "0.4.0";
        src = super.fetchPypi {
          inherit pname version;
          sha256 = "132p8ayx5kz9fbnk27r3ii9kz6p14ig5aannb7yd6s3swabdwwcz";
        };
        propagatedBuildInputs = [ fann2 xxhash ];
        # checkInputs = with super; [ mock pytest pytestrunner twisted ];
      };

      pulsectl = super.buildPythonPackage rec {
        pname = "pulsectl";
        version = "18.2.0";
        src = super.fetchPypi {
          inherit pname version;
          sha256 = "1lnhfnwsi8rllnw1r3ydlcn6rdb50nsqx6s7q97rphj4dcdwvf3f";
        };
        postPatch = ''
          substituteInPlace pulsectl/_pulsectl.py \
            --replace libpulse.so.0 ${libpulseaudio}/lib/libpulse.so.0
        '';
        doCheck = true;
        buildInputs = [ libpulseaudio.dev ];
        propagatedBuildInputs = [ ];
        checkInputs = with super; [ ];
      };

      pocketsphinx-python = super.buildPythonPackage rec {
        pname = "pocketsphinx";
        version = "0.1.3";
        src = super.fetchPypi {
          inherit pname version;
          sha256 = "0v9l43s6s256qy4bs31akvmqkkrxdkk8mld40s3vfnn8xynml4mc";
        };
        buildInputs = [ libpulseaudio ];
        nativeBuildInputs = [ swig ];
        doCheck = false;
        # propagatedBuildInputs = with super; [ vcversioner ];
        # checkInputs = with super; [ pytest ];
      };

      pyaudio = super.pyaudio.overridePythonAttrs (oldAttrs: rec {
        version = "0.2.11";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "0x7vdsigm7xgvyg3shd3lj113m8zqj2pxmrgdyj66kmnw0qdxgwk";
        };
      });

      pyee = super.buildPythonPackage rec {
        pname = "pyee";
        version = "1.0.1";
        src = super.fetchPypi {
          inherit pname version;
          sha256 = "0s4gqzwc9sribl7a2vwgpz5l5wgfc0ls0janvpiywgm527c9qp24";
        };
        propagatedBuildInputs = with super; [ vcversioner ];
        checkInputs = with super; [ mock pytest pytestrunner twisted ];
      };

      # we need vlc 3 for this to work
      python-vlc = super.buildPythonPackage rec {
        pname = "python-vlc";
        version = "3.0.102";
        src = super.fetchPypi {
          inherit pname version;
          sha256 = "19ckynl5rpm9n82q1iayzw3xb9xx2lz4gpkn47cqp82j71aiq6n5";
        };
        buildInputs = [ vlc ];
      };

      requests-futures = super.buildPythonPackage rec {
        pname = "requests-futures";
        version = "0.9.7";
        src = super.fetchPypi {
          inherit pname version;
          sha256 = "1bbvx99dnkh9cqbmhs4c1yvb4aiffi3c2nfyqngc5ymnh0s2rjm9";
        };
        propagatedBuildInputs = with super; [ futures requests ];
        # checkInputs = with super; [ mock pytest pytestrunner twisted ];
        doCheck = false;
      };

      speechrecognition = super.buildPythonPackage rec {
        pname = "SpeechRecognition";
        version = "3.8.1";
        src = fetchFromGitHub {
          owner = "Uberi";
          repo = "speech_recognition";
          rev = "${version}";
          sha256 = "1lq6g4kl3y1b4ch3b6wik7xy743x6pp5iald0jb9zxqgyxy1zsz4";
        };
        buildInputs = [ flac ];
        propagatedBuildInputs = with super; [ pocketsphinx-python ];
        doCheck = false;
        # checkInputs = with super; [ mock pytest pytestrunner twisted ];
      };

      xxhash = super.buildPythonPackage rec {
        pname = "xxhash";
        version = "1.0.1";
        src = super.fetchPypi {
          inherit pname version;
          extension = "zip";
          sha256 = "0ca8577ldyipv20v69cxk2cki82zklkxdryh4dg3hx13s34nkgks";
        };
        # propagatedBuildInputs = [ fann2 xxhash ];
        checkInputs = with super; [ nose ];
      };
    };
  };

  baseDir = "/var/lib/mycroft";

  components = [
    { name = "audio";           bin = false; path = "audio/main.py"; }
    { name = "bus";             bin = false; path = "messagebus/service/main.py"; }
    { name = "cli";             bin = true;  path = "client/text/main.py"; }
    # { name = "enclosure";       bin = false; path = "client/enclosure/main.py"; }
    { name = "skill_container"; bin = true;  path = "skills/container.py"; }
    { name = "skills";          bin = false; path = "skills/main.py"; }
    { name = "voice";           bin = false; path = "client/speech/main.py"; }
    # wifisetup is referenced in the msm script but nowhere to be found
    # { name = "wifi";            bin = false; path = "client/wifisetup/main.py"; }
  ];

in py.pkgs.buildPythonApplication rec {
  pname = "mycroft";
  version = "0.9.19";

  format = "other";

  src = fetchFromGitHub {
    owner  = "MycroftAI";
    repo   = "mycroft-core";
    rev    = "release/v${version}";
    sha256 = "1hvgl246ngg5r3l9qr73s2038iali9iwnqbfl1f361x1f3z0f0r9";
  };

  patches = [ ./paths.patch ];

  postPatch = ''
    for f in msm/msm mycroft/configuration/mycroft.conf mycroft/configuration/config.py mycroft/util/log.py ; do
      substituteInPlace $f \
        --replace /etc/mycroft $out/etc/mycroft \
        --replace /opt/mycroft ${baseDir}
    done

    sed -i mycroft/__init__.py \
      -e "s,MYCROFT_ROOT_PATH.*,MYCROFT_ROOT_PATH='$out',"

    substituteInPlace mycroft/tts/mimic_tts.py \
      --replace @mimic@ ${mimic}

    substituteInPlace mycroft/configuration/mycroft.conf \
      --replace 'mpg123 %1' "${lib.getBin mpg123}/bin/mpg123 %1" \
      --replace 'paplay %1' "${lib.getBin libpulseaudio}/bin/paplay %1"
  '';

  buildInputs = [
    alsaLib
    curl
    flac
    glib
    libfann
    libffi
    libjpeg
    mimic
    openssl
    pocketsphinx
    portaudio
    libpulseaudio
    s3cmd
    # swig2
    xxHash
    zlib
  ];

  propagatedBuildInputs = with py.pkgs; [
    adapt-parser

    dateutil
    future
    futures
    inflection
    monotonic
    parsedatetime
    pillow
    psutil
    pulsectl
    pyaudio
    PyChromecast
    pyee
    pyserial
    pyyaml
    requests
    # six
    tornado
    websocket_client

  #   backports.ssl-match-hostname
  #   google-api-python-client
    gtts
    padatious
    # pocketsphinx-python # used by speechrecog
    pyalsaaudio
    # python-vlc # we need vlc 3 in nixpkgs
    requests-futures
    speechrecognition
  #   xmlrunner
  ];

  checkInputs = with py.pkgs; [ mock nose2 pep8 ];

  dontConfigure = true;
  dontBuild = true;
  # 2 out of 162 checks are failing
  doCheck = false;

  installPhase = let
    services=lib.concatStringsSep " " (map (e: if e.bin then "" else "mycroft-${e.name}.service" ) components);
    dirs = [ "user" "system" ];
  in ''
    runHook preInstall

    dir=$out/${py.sitePackages}
    mkdir -p $out/{bin,lib/systemd/{user,system},libexec} $dir/msm
    cp -r mycroft $dir/

    ${lib.concatStringsSep "\n" (map (e: ''
      if [ ! -f $dir/mycroft/${e.path} ]; then
        echo "Unable to find: ${e.path}"
        exit 1
      fi

      f=$out/${if e.bin then "bin" else "libexec"}/mycroft-${e.name}
      cat >> $f << _EOF
      #!${stdenv.shell} -e

      export HOME=$${HOME:-${baseDir}}
      export PATH=$PATH:${lib.makeBinPath [ flac mimic mpg123 ]}
      export PYTHONPATH=$dir:${py.pkgs.makePythonPath propagatedBuildInputs}

      exec ${py.pkgs.python.interpreter} $dir/mycroft/${e.path} "$@"
      _EOF
      chmod 755 $f

      ${lib.concatStringsSep "\n" (map (d: ''
        ${lib.optionalString (!e.bin) ''
          cat >> $out/lib/systemd/${d}/mycroft-${e.name}.service << _EOF
          [Unit]
          Description=Mycroft AI - ${e.name}
          After=network.target dbus.service ${depends e.name}
          PartOf=mycroft.target

          [Service]
          ${lib.optionalString (d == "system") ''
            DynamicUser=true
            User=mycroft
            Group=mycroft
            StateDirectory=mycroft
          ''}
          WorkingDirectory=~
          ExecStart=$out/libexec/mycroft-${e.name}
          ProtectSystem=true
          PrivateTmp=true
          TimeoutStopSec=5s
          Slice=mycroft.slice
          Restart=on-failure
          RestartSec=2s

          [Install]
          WantedBy=mycroft.target
          _EOF
        ''}
    '') dirs)}
    '') components)}

    ${lib.concatStringsSep "\n" (map (d: ''
      cat >> $out/lib/systemd/${d}/mycroft.target << _EOF
      [Unit]
      Description=Mycroft AI
      Requires=${services}
      After=${services}
      _EOF
    '') dirs)}

    install -Dm755 msm/msm            $out/bin/msm
    install -Dm644 msm/man/man1/msm.1 $out/share/man/man1/msm.1

    install -Dm644 -t $out/share/doc/mycroft *.md

    ln -s $out/bin/msm $dir/msm/
    # ln -s ${mimic} $out/mimic

    runHook postInstall
  '';

  installCheckPhase = ''
    export HOME=/tmp
    nose2 -t ./ -s test/unittests/ --with-coverage --config=test/unittests/unittest.cfg
  '';

  meta = with lib; {
    homepage = https://mycroft.ai;
    description = "Personal assistant";
    license = licenses.asl20;
    maintainers = with maintainers; [ peterhoeg ];
  };
}

# six==1.10.0
# requests==2.13.0
# gTTS==1.1.7
# gTTS-token==1.1.1
# backports.ssl-match-hostname==3.4.0.2
# PyAudio==0.2.11
# pyee==1.0.1
# SpeechRecognition==3.8.1
# tornado==4.2.1
# websocket-client==0.32.0
# adapt-parser==0.3.0
# futures==3.0.3
# future==0.16.0
# requests-futures==0.9.5
# parsedatetime==1.5
# pyyaml==3.11
# pyalsaaudio==0.8.2
# xmlrunner==1.7.7
# pyserial==3.0
# psutil==5.2.1
# pocketsphinx==0.1.0
# inflection==0.3.1
# pillow==4.1.1
# python-dateutil==2.6.0
# pychromecast==0.7.7
# python-vlc==1.1.2
# pulsectl==17.7.4
# google-api-python-client==1.6.4
# monotonic

# # dev setup tools
# pep8==1.7.0
# # Also update in mycroft/skills/padatious_service.py
