{ stdenv
, fetchFromGitHub
, python3
}:

stdenv.mkDerivation rec {
  pname = "tridactyl-native";
  # this is actually the version of tridactyl itself; the native messenger will
  # probably not change with every tridactyl version
  version = "1.20.0";

  src = fetchFromGitHub {
    owner = "tridactyl";
    repo = "tridactyl";
    rev = version;
    sha256 = "14p6jadw4yij45rrwjbyf1lq3zpsni4sph88c6mlwlf8w830s3q8";
  };
  sourceRoot = "source/native";

  nativeBuildInputs = [
    python3.pkgs.wrapPython
  ];

  buildPhase = ''
    sed -i -e "s|REPLACE_ME_WITH_SED|$out/share/tridactyl/native_main.py|" "tridactyl.json"
  '';

  installPhase = ''
    mkdir -p "$out/lib/mozilla/native-messaging-hosts"
    cp tridactyl.json "$out/lib/mozilla/native-messaging-hosts/"

    mkdir -p "$out/share/tridactyl"
    cp native_main.py "$out/share/tridactyl"
    wrapPythonProgramsIn "$out/share/tridactyl"
  '';

  meta = with stdenv.lib; {
    description = "Tridactyl native messaging host application";
    homepage = "https://github.com/tridactyl/tridactyl";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ timokau ];
  };
}
