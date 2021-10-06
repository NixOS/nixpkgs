{ pkgs, lib, stdenv, fetchzip, nixosTests, dataDir ? "/var/lib/crater" }:

stdenv.mkDerivation rec {
  pname = "crater";
  version = "4.2.0";

  src = fetchzip {
    url = "https://craterapp.com/downloads/file/${version}";
    sha256 = "sha256-7nqr4GtvW5m3qu6LJhulBbe+X7k1Thifa/X2aXFHz3Y=";
    # postFetch is necessary because the downloaded file does not match the
    # filename in the URL since it is a redirect. fetchzip attempts to wrongly use
    # this name.
    postFetch = ''unzip $downloadedFile -d $out '';
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    cp -ra crater $out

    # symlink mutable data into the nix store due to crater path requirements
    rm -R $out/storage $out/.env
    ln -s ${dataDir}/.env $out/.env
    ln -s ${dataDir}/storage $out/storage
    ln -s ${dataDir}/public/storage $out/public/storage

    runHook postInstall
  '';

  # getPath() returns a nix store path, which may not be valid, requiring this
  # patch. Upstream issue can be found here:
  # https://github.com/bytefury/crater/issues/578
  patches = [ ./remove-getpath.patch ];

  patchFlags = [ "-p1" "-d crater" ];

  postPatch = ''
    substituteInPlace crater/app/Http/Controllers/V1/Onboarding/DatabaseConfigurationController.php \
      --replace "database_path('database.sqlite')" "'${dataDir}/database.sqlite'"

    substituteInPlace crater/config/mail.php \
      --replace "'sendmail' => '/usr/sbin/sendmail -bs'" "'sendmail' => '${pkgs.system-sendmail}/bin/sendmail -bs'"
  '';

  passthru.tests = nixosTests.crater;

  meta = with lib; {
    description = "Free & Open Source Invoice App for Freelancers & Small Businesses";
    license = licenses.aal ;
    homepage = "https://craterapp.com/";
    maintainers = with maintainers; [ matthewcroughan ];
    platforms = platforms.all;
  };
}
