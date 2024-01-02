{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cringify";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "sansyrox";
    repo = "cringify";
    rev = "dd753818f8dd4b343be9370d2c29a6be070ad791";
    hash = "sha256-6hSgOk9DzDfGtZX1vt6AQsKSLdPdqy2Mz3UtK6d2AuA=";
  };

  cargoHash = "sha256-w6lqPyUCaXZBQ1EmMyj0sVnEHugMD6JugIIK0rEa19Y=";

  postPatch = ''
    # Upstream forgot to update the version value
    substituteInPlace src/main.rs --replace '0.1.0' ${version}
  '';

  # No tests are present in the repository
  doCheck = false;

  meta = {
    description = "Annoy your friends with the cringified text";
    homepage = "https://github.com/sansyrox/cringify";
    license = lib.licenses.mit;
    mainProgram = "cringify";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
