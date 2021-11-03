{ lib
, openssl
, rsync
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "lxd-image-server";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "Avature";
    repo = "lxd-image-server";
    rev = version;
    sha256 = "yx8aUmMfSzyWaM6M7+WcL6ouuWwOpqLzODWSdNgwCwo=";
  };

  patches = [
    ./state.patch
    ./run.patch
  ];

  propagatedBuildInputs = with python3.pkgs; [
    setuptools
    attrs
    click
    inotify
    cryptography
    confight
    python-pidfile
  ];

  makeWrapperArgs = [
    ''--prefix PATH ':' "${lib.makeBinPath [ openssl rsync ]}"''
  ];

  doCheck = false;

  meta = with lib; {
    description = "Creates and manages a simplestreams lxd image server on top of nginx";
    homepage = "https://github.com/Avature/lxd-image-server";
    license = licenses.apsl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ mkg20001 ];
  };
}
