{ lib
, fetchFromGitHub
, nixosTests
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "notify_push";
  version = "0.6.6";

  src = fetchFromGitHub {
    owner = "nextcloud";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-9wVH+msUh0t0PKz+5044PhT9lGsbfp4u44gX0O70Pbo=";
  };

  cargoHash = "sha256-Q4KA+mc48OfmxYY7vDJ2ZU/Wd+101kbimwAw6ag3d+w=";

  passthru = rec {
    test_client = rustPlatform.buildRustPackage {
      pname = "${pname}-test_client";
      inherit src version;

      buildAndTestSubdir = "test_client";

      cargoHash = "sha256-XiaeCVgVjre7NmH/B+dNw0u2HV0vJwlgDjhLXXgJS+Y=";
    };
    tests = {
      inherit (nixosTests.nextcloud)
        with-postgresql-and-redis26
        with-postgresql-and-redis27
        with-postgresql-and-redis28;
      inherit test_client;
    };
  };

  meta = with lib; {
    description = "Update notifications for nextcloud clients";
    homepage = "https://github.com/nextcloud/notify_push";
    license = licenses.agpl3Plus;
    maintainers = teams.helsinki-systems.members;
  };
}
