{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "lfs";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-c52ArXTpzGlY4+yXY1hQfZxoFvgRfpzMRqnF36DHaaI=";
  };

  cargoSha256 = "sha256-iQqEkyG+tg0l7I9fp2bT5KKzR9047c5xj4QuhWncNuE=";

  meta = with lib; {
    description = "Get information on your mounted disks";
    homepage = "https://github.com/Canop/lfs";
    license = licenses.mit;
    maintainers = with maintainers; [ koral ];
  };
}
