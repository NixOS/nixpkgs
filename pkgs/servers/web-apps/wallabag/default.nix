{ lib
, stdenv
, fetchurl
, fetchpatch
}:

# Point the environment variable $WALLABAG_DATA to a data directory
# that contains the folder `app` which must be a clone of
# wallabag's configuration files with your customized `parameters.yml`.
# In practice you need to copy `${pkgs.wallabag}/app` and the
# customizzed `parameters.yml` to $WALLABAG_DATA.
# These need to be updated every package upgrade.
#
# After a package upgrade, empty the `var/cache` folder or unexpected
# error will occur.

let
  pname = "wallabag";
  version = "2.5.3";
in
stdenv.mkDerivation {
  inherit pname version;

  # Release tarball includes vendored files
  src = fetchurl {
    urls = [
      "https://static.wallabag.org/releases/wallabag-release-${version}.tar.gz"
      "https://github.com/wallabag/wallabag/releases/download/${version}/wallabag-${version}.tar.gz"
    ];
    hash = "sha256-a30z9rdXcfc2eVuShEobgDWWHr9TfMwq9WwaWdrI3QU=";
  };

  patches = [
    ./wallabag-data.patch # exposes $WALLABAG_DATA

    # Use sendmail from php.ini instead of FHS path.
    (fetchpatch {
      url = "https://github.com/symfony/swiftmailer-bundle/commit/31a4fed8f621f141ba70cb42ffb8f73184995f4c.patch";
      stripLen = 1;
      extraPrefix = "vendor/symfony/swiftmailer-bundle/";
      sha256 = "rxHiGhKFd/ZWnIfTt6omFLLoNFlyxOYNCHIv/UtxCho=";
    })
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -R * $out/

    runHook postInstall
  '';

  meta = with lib; {
    description = "wallabag is a self hostable application for saving web pages";
    longDescription = ''
      wallabag is a self-hostable PHP application allowing you to not
      miss any content anymore. Click, save and read it when you can.
      It extracts content so that you can read it when you have time.
    '';
    license = licenses.mit;
    homepage = "http://wallabag.org";
    changelog = "https://github.com/wallabag/wallabag/releases/tag/${version}";
    maintainers = with maintainers; [ schneefux ];
    platforms = platforms.all;
  };
}
