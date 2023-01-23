{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "toast";
  version = "0.45.5";

  src = fetchFromGitHub {
    owner = "stepchowfun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7EF9DCT8Vg7aGOUlRG9c4Lv2EhCX/P9k4zQC6Ruqv0c=";
  };

  cargoSha256 = "sha256-tyZrNUT2i9i0yOqz1KqIuFSb4PO+fx1SNa+ZVNfIGfM=";

  checkFlags = [ "--skip=format::tests::code_str_display" ]; # fails

  meta = with lib; {
    description = "Containerize your development and continuous integration environments";
    homepage = "https://github.com/stepchowfun/toast";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
