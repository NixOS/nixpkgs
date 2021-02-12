{ lib, stdenv, rustPlatform, fetchFromGitHub, Security }:

rustPlatform.buildRustPackage rec {
  pname = "martin";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "urbica";
    repo = pname;
    rev = "v${version}";
    sha256 = "1i9zhmjkgid4s90n52wqmrl3lwswcaxd6d47ssycgjl1nv0jla4k";
  };

  cargoSha256 = "1pdb8p9ya918pdgx6374qnd8c08bqhhbbdiavif1f40yxvjcml1v";

  buildInputs = with stdenv; lib.optional isDarwin Security;

  doCheck = false;

  meta = with lib; {
    description = "Blazing fast and lightweight PostGIS vector tiles server";
    homepage = "https://martin.urbica.co/";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    platforms = with platforms; linux ++ darwin;
  };
}
