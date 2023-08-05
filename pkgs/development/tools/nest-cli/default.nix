{ buildNpmPackage
, fetchFromGitHub
, lib
}:

buildNpmPackage rec {
  pname = "nest-cli";
  version = "9.4.2";

  src = fetchFromGitHub {
    owner = "nestjs";
    repo = pname;
    rev = version;
    hash = "sha256-9I6ez75byOPVKvX93Yv1qSM3JaWlmmvZCTjNB++cmw0=";
  };

  # Generated a new package-lock.json by running `npm upgrade`
  # The upstream lockfile is using an old version of `fsevents`,
  # which does not build on Darwin
  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  npmDepsHash = "sha256-QA2ZgbXiG84HuutJ2ZCGMrnqpwrPlHL/Bur7Pak8WcQ=";

  meta = with lib; {
    description = "CLI tool for Nest applications 🍹";
    homepage = "https://nestjs.com";
    license = licenses.mit;
    maintainers = [ maintainers.ehllie ];
  };
}
