{ rustPlatform
, fetchFromGitHub
, lib
}: rustPlatform.buildRustPackage rec {

  pname = "bkt";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "dimo414";
    repo = pname;
    rev = version;
    sha256 = "sha256-CMCO1afTWhXlWpy9D7txqI1FHxGDgdVdkKtyei6oFJU=";
  };

  cargoHash = "sha256-T4JT8GzKqsQQfe3zfst6gNEvdY7zs2h2H3s6slaRhYY=";

  meta = {
    description = "A subprocess caching utility";
    homepage = "https://github.com/dimo414/bkt";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.mangoiv ];
    mainProgram = "bkt";
  };
}
