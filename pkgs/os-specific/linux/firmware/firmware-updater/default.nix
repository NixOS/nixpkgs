{ lib
, writeText
, flutter
, fetchFromGitHub
}:

flutter.buildFlutterApplication rec {
  pname = "firmware-updater";
  version = "unstable-2023-09-17";

  pubspecLockFile = ./pubspec.lock;
  depsListFile = ./deps.json;
  vendorHash = "sha256-5xd9ppnWleKVA69DJWVdY+rZziu4dQBCu16I0ivD8kE=";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "firmware-updater";
    rev = "855999da8d3d0c9930e06f2d296d82b55aeff79e";
    hash = "sha256-tIeEuHl+sCKd756NYPmxXiV1Sg2m9W0eGUtM/Iskeu8=";
  };

  postPatch = ''
    rm -f pubspec.lock
    ln -s "${writeText "${pname}-overrides.yaml" (builtins.toJSON {
      dependency_overrides = {
        yaru = "^1.1.0";
        yaru_icons = "^2.2.1";
        yaru_widgets = "^3.1.0";
        mockito = "^5.4.2";
        test_api = "^0.6.1";
      };
    })}" pubspec_overrides.yaml
  '';

  meta = with lib; {
    description = "Firmware Updater for Linux";
    homepage = "https://github.com/canonical/firmware-updater";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ mkg20001 ];
    platforms = platforms.linux;
  };
}
