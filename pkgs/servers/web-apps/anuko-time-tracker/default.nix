{ lib
, stdenvNoCC
, fetchFromGitHub
, nixosTests
, php
}:

stdenvNoCC.mkDerivation rec {
  pname = "anuko-time-tracker";
  version = "1.22.19.5806";

  # Project commits directly into master and has no release schedule.
  # Fortunately the current version is defined in the 'APP_VERSION' constant in
  # /initialize.php so we use its value and set the rev to the commit sha of when the
  # constant was last updated.
  src = fetchFromGitHub {
    owner = "anuko";
    repo = "timetracker";
    rev = "43a19fcb51a21f6e3169084ac81308a6ef751e63";
    hash = "sha256-ZRF9FFbntYY01JflCXkYZyXfyu/x7LNdyOB94UkVFR0=";
  };

  # There's nothing to build.
  dontBuild = true;

  installPhase = ''
    mkdir $out/
    cp -R ./* $out
  '';

  passthru.tests = {
    inherit (nixosTests) anuko-time-tracker;
  };

  meta = {
    description = "Simple, easy to use, open source time tracking system";
    license = lib.licenses.sspl;
    homepage = "https://github.com/anuko/timetracker/";
    platforms = php.meta.platforms;
    maintainers = with lib.maintainers; [ michaelshmitty ];
  };
}
