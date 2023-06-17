{ rustPlatform
, fetchFromGitHub
, lib
}: rustPlatform.buildRustPackage rec {

  pname = "bkt";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "dimo414";
    repo = pname;
    rev = version;
    sha256 = "sha256-NgNXuTpI1EzgmxKRsqzxTOlQi75BHCcbjFnouhnfDDM=";
  };

  cargoSha256 = "sha256-PvcKviyXtiHQCHgJLGR2Mr+mPpTd06eKWQ5h6eGdl40=";

  meta = {
    description = "A subprocess caching utility";
    homepage = "https://github.com/dimo414/bkt";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.mangoiv ];
    mainProgram = "bkt";
  };
}
