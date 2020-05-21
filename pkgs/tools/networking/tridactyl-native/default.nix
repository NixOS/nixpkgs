{ stdenv
, fetchFromGitHub
, python3
}:

stdenv.mkDerivation rec {
  pname = "tridactyl-native";
  # this is actually the version of tridactyl itself; the native messenger will
  # probably not change with every tridactyl version
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "tridactyl";
    repo = "tridactyl";
    rev = version;
    sha256 = "1myqhhjilj9sjvvw64f2931jqgvwv60ajqngw790ygcs4vr7gmfk";
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
