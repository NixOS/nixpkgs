{ stdenv
, fetchFromGitHub
, buildComposerPackage
  # If Laravel fails to bootstrap the application, then it fails with a cryptic
  # "class Log not found" error, which could be due to a syntax error in the configuration,
  # failed database connection, PHP syntax error or any number of other things - swapping this
  # value prints the actual exception to the browser.
, revealLaravelError ? false,
}:

buildComposerPackage rec {
  pname = "snipe-it";
  version = "4.8.0";

  src = fetchFromGitHub {
    owner = "snipe";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "1r00g5pf428zc501jw1bcjg9w73m41mq510r8an38ad3x51w8nxf";
  };

  composerHash = "0zrlqgg8dgb18qnvl2jhl38pllcqhzrjhib9m8h0b5n0ia5dip7q";

  patches = [
    ./00-laravel-env.patch
    ./01-snipeit-public-upload-env.patch
  ] ++ stdenv.lib.optional revealLaravelError [
    ./02-display-framework-errors.patch
  ];

  installPhase = ''
    mkdir $out
    cp -r * $out/
  '';

  meta = with stdenv.lib; {
    description = "A free open source IT asset/license management system";
    license = licenses.agpl3;
    homepage = "https://snipeitapp.com/";
    platforms = platforms.all;
    maintainers = with maintainers; [ davidtwco ];
  };
}
