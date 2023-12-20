{ lib, fetchzip, nixosTests, ... }:

fetchzip rec {
  pname = "vikunja-frontend";
  version = "0.22.0";

  url = "https://dl.vikunja.io/frontend/${pname}-${version}.zip";
  hash = "sha256-mMfK+58nN014ta09/mTbz/6BgQIBj6DqJSPaRtGZ3A8=";

  stripRoot = false;

  passthru.tests.vikunja = nixosTests.vikunja;

  meta = {
    changelog = "https://kolaente.dev/vikunja/frontend/src/tag/v${version}/CHANGELOG.md";
    description = "Frontend of the Vikunja to-do list app";
    homepage = "https://vikunja.io/";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ leona ];
    platforms = lib.platforms.all;
  };
}
