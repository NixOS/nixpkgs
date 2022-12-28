{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "tere";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "mgunyho";
    repo = "tere";
    rev = "v${version}";
    sha256 = "sha256-/712LB7oc27BP5WM20Pk3AucjwDJeBgH7udTgA+jFKc=";
  };

  cargoSha256 = "sha256-Z+qOID2/GRJTzAEWlUUTv6LAKLALu2Vn1umvrAgem00=";

  postPatch = ''
    rm .cargo/config.toml;
  '';

  meta = with lib; {
    description = "A faster alternative to cd + ls";
    homepage = "https://github.com/mgunyho/tere";
    license = licenses.eupl12;
    maintainers = with maintainers; [ ProducerMatt ];
  };
}
