{ lib
, fetchFromGitLab
, python3
}:
let
  py = python3.override {
    packageOverrides = self: super: {

      cmd2 = super.cmd2.overridePythonAttrs (oldAttrs: rec {
        version = "1.5.0";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "0qiax309my534drk81lihq9ghngr96qnm40kbmgc9ay4fncqq6kh";
        };
        doCheck = false;
      });
    };
  };
in
with py.pkgs;

buildPythonApplication rec {
  pname = "expliot";
  version = "0.9.8";

  src = fetchFromGitLab {
    owner = "expliot_framework";
    repo = pname;
    rev = version;
    hash = "sha256-7Cuj3YKKwDxP2KKueJR9ZO5Bduv+lw0Y87Rw4b0jbGY=";
  };

  propagatedBuildInputs = [
    aiocoap
    awsiotpythonsdk
    bluepy
    can
    cmd2
    cryptography
    paho-mqtt
    pyi2cflash
    pymodbus
    pynetdicom
    pyparsing
    pyserial
    pyspiflash
    upnpy
    xmltodict
    zeroconf
  ];

  postPatch = ''
    # https://gitlab.com/expliot_framework/expliot/-/merge_requests/113
    substituteInPlace setup.py \
      --replace "pynetdicom>=1.5.1,<2" "pynetdicom>=2,<3" \
      --replace "cryptography>=3.0,<4" "cryptography>=35,<40" \
      --replace "python-can>=3.3.3,<4" "python-can>=3.3.3,<5" \
      --replace "pyparsing>=2.4.7,<3" "pyparsing>=2.4.7,<4"
  '';

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "expliot"
  ];

  meta = with lib; {
    description = "IoT security testing and exploitation framework";
    longDescription = ''
      EXPLIoT is a Framework for security testing and exploiting IoT
      products and IoT infrastructure. It provides a set of plugins
      (test cases) which are used to perform the assessment and can
      be extended easily with new ones. The name EXPLIoT (pronounced
      expl-aa-yo-tee) is a pun on the word exploit and explains the
      purpose of the framework i.e. IoT exploitation.
    '';
    homepage = "https://expliot.readthedocs.io/";
    license = with licenses; [ agpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
