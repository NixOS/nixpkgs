{ stdenv, fetchzip, php, writeText, nixosTests }:

let
  phpExt = php.withExtensions
    ({ enabled, all }: with all; [ json filter mysqlnd mysqli pdo pdo_mysql ]);
in stdenv.mkDerivation rec {
  pname = "engelsystem";
  version = "3.1.0";

  src = fetchzip {
    url =
      "https://github.com/engelsystem/engelsystem/releases/download/v3.1.0/engelsystem-v3.1.0.zip";
    sha256 = "01wra7li7n5kn1l6xkrmw4vlvvyqh089zs43qzn98hj0mw8gw7ai";
    # This is needed, because the zip contains a directory with world write access, which is not allowed in nix
    extraPostFetch = "chmod -R a-w $out";
  };

  buildInputs = [ phpExt ];

  installPhase = ''
    runHook preInstall

    # prepare
    rm -r ./storage/
    rm -r ./docker/

    ln -sf /etc/engelsystem/config.php ./config/config.php
    ln -sf /var/lib/engelsystem/storage/ ./storage

    mkdir -p $out/share/engelsystem
    mkdir -p $out/bin
    cp -r . $out/share/engelsystem

    echo $(command -v php)
    # The patchShebangAuto function always used the php without extensions, so path the shebang manually
    sed -i -e "1 s|.*|#\!${phpExt}/bin/php|" "$out/share/engelsystem/bin/migrate"
    ln -s "$out/share/engelsystem/bin/migrate" "$out/bin/migrate"

    runHook postInstall
  '';

  passthru.tests = nixosTests.engelsystem;

  meta = with stdenv.lib; {
    description =
      "Coordinate your helpers in teams, assign them to work shifts or let them decide for themselves when and where they want to help with what";
    license = licenses.gpl2;
    homepage = "https://engelsystem.de";
    maintainers = with maintainers; [ kloenk ];
    platforms = platforms.all;
  };
}
