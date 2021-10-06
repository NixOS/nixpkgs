{ lib
, stdenv
, pkgs
, fetchzip
, nixosTests
, dataDir ? "/var/lib/crater"
}:

stdenv.mkDerivation rec {
  pname = "crater";
  version = "6.0.6";

  src = fetchzip {
    url = "https://craterapp.com/downloads/file/${version}";
    hash = "sha256-g+T/V+iypD6H0n8y1X7m2T6xRlYxO86aVV/yxhwHVa8=";
    extension = "zip";
    stripRoot=false;
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    cp -ra crater $out

    # symlink mutable data into the nix store due to crater path requirements
    rm -r $out/storage $out/.env $out/bootstrap/cache $out/database/database.sqlite
    ln -s ${dataDir}/.env $out/.env
    ln -s ${dataDir}/storage $out/storage
    ln -s ${dataDir}/public/storage $out/public/storage
    ln -s ${dataDir}/bootstrap/cache $out/bootstrap/cache
    ln -s ${dataDir}/database.sqlite $out/database/database.sqlite

    runHook postInstall
  '';

  postPatch = ''
    # Change default sqlite database path to absolute path since symlinks are
    # not followed by crater/lavarel
    substituteInPlace crater/app/Http/Controllers/V1/Installation/DatabaseConfigurationController.php \
      --replace "database_path('database.sqlite')" "'${dataDir}/database.sqlite'"

    substituteInPlace crater/config/mail.php \
      --replace "'sendmail' => '/usr/sbin/sendmail -bs'" "'sendmail' => '${pkgs.system-sendmail}/bin/sendmail -bs'"
  '';

  passthru.tests = nixosTests.crater;

  meta = with lib; {
    description = "Free & Open Source Invoice App for Freelancers & Small Businesses";
    license = licenses.aal ;
    homepage = "https://craterapp.com";
    maintainers = with maintainers; [ onny ];
    platforms = platforms.all;
  };
}
