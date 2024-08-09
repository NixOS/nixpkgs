{
  stdenv,
  fetchurl,
  lib,
  nodejs,
  ...
}:
stdenv.mkDerivation rec {
  pname = "nextcloud-app-recognise";
  version = "6.0.1";

  srcs = [
    (fetchurl {
      inherit version;
      url = "https://github.com/nextcloud/recognize/releases/download/v${version}/recognize-${version}.tar.gz";
      hash = "sha256-HQHfcQY2N6INLfaLDWbWn0SSzvkSZqL0rPl2koqej6c=";
    })

    (fetchurl {
      inherit version;
      url = "https://github.com/nextcloud/recognize/archive/refs/tags/v${version}.tar.gz";
      hash = "sha256-4iJVKz/HfzIUouiOK/NUkJUm4+p9meVptQwJ4OG1JaU=";
    })
  ];

  unpackPhase = ''
    tar -xzpf "${builtins.elemAt srcs 0}" recognize;
    tar -xzpf "${builtins.elemAt srcs 1}" recognize-${version}/models;
    mv recognize-${version}/models recognize
    sed -i "/'node_binary'/s:'""':'${nodejs}/bin/node':" recognize/lib/Service/SettingsService.php
  '';

  installPhase = ''
    approot="$(dirname $(dirname $(find -path '*/appinfo/info.xml' | head -n 1)))"
    if [ -d "$approot" ];
    then
      mv "$approot/" $out
      chmod -R a-w $out
    fi
  '';

  meta = with lib; {
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ beardhatcode ];
    longDescription = ''
      Nextcloud app that does Smart media tagging and face recognition with on-premises machine learning models.
      This app goes through your media collection and adds fitting tags, automatically categorizing your photos and music.
    '';
    homepage = "https://apps.nextcloud.com/apps/recognize";
  };
}
