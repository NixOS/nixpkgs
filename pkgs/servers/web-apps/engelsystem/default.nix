{ lib
, fetchzip
, nixosTests
, php
, stdenv
, writeText
}:

stdenv.mkDerivation rec {
  pname = "engelsystem";
  version = "3.5.0";

  src = fetchzip {
    url = "https://github.com/engelsystem/engelsystem/releases/download/v${version}/engelsystem-v${version}.zip";
    hash = "sha256-RbzAHBZN02u14WaLtq5EOh4XwIdHKvzX7NhDBhn/CaU=";
  };

  buildInputs = [ php ];

  installPhase = ''
    runHook preInstall

    # prepare
    rm -r ./storage/

    ln -sf /etc/engelsystem/config.php ./config/config.php
    ln -sf /var/lib/engelsystem/storage/ ./storage

    mkdir -p $out/share/engelsystem
    mkdir -p $out/bin
    cp -r . $out/share/engelsystem

    echo $(command -v php)
    # The patchShebangAuto function always used the php without extensions, so path the shebang manually
    sed -i -e "1 s|.*|#\!${lib.getExe php}|" "$out/share/engelsystem/bin/migrate"
    ln -s "$out/share/engelsystem/bin/migrate" "$out/bin/migrate"

    runHook postInstall
  '';

  passthru.tests = nixosTests.engelsystem;

  meta = with lib; {
    changelog = "https://github.com/engelsystem/engelsystem/releases/tag/v${version}";
    description =
      "Coordinate your volunteers in teams, assign them to work shifts or let them decide for themselves when and where they want to help with what";
    homepage = "https://engelsystem.de";
    license = licenses.gpl2Only;
    mainProgram = "migrate";
    maintainers = [ ];
    platforms = platforms.all;
  };
}
