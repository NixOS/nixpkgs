{ buildPythonPackage
, dbus-python
, fetchFromGitHub
, numpy
, stdenv
, openrazer-daemon
}:

let
  openrazerSrc = import ./src.nix;
in
buildPythonPackage rec {
  inherit (openrazerSrc) version;
  pname = "openrazer";

  src = fetchFromGitHub openrazerSrc.github;
  sourceRoot = "source/pylib";

  propagatedBuildInputs = [
    dbus-python
    numpy
    openrazer-daemon
  ];

  meta = with stdenv.lib; {
    description = "An entirely open source driver and user-space daemon that allows you to manage your Razer peripherals on GNU/Linux";
    homepage = https://openrazer.github.io/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ roelvandijk ];
    platforms = platforms.linux;
  };
}
