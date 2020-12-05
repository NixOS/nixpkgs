{ stdenv, lib, fetchFromGitHub, rustPlatform, Foundation, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "topgrade";
  version = "6.0.1";

  src = fetchFromGitHub {
    owner = "r-darwish";
    repo = pname;
    rev = "v${version}";
    sha256 = "1bpq4zki98vw793rvrk9qwgh62f1qwzh0cm4a3h0bif43kg836n0";
  };

  cargoSha256 = "1486pfiv4lfzdz3hj5z6s7q8lhzrldffji3fsf10z50sm4fhq73q";

  buildInputs = lib.optional stdenv.isDarwin Foundation;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage topgrade.8
  '';

  meta = with lib; {
    description = "Upgrade all the things";
    homepage = "https://github.com/r-darwish/topgrade";
    license = licenses.gpl3;
    maintainers = with maintainers; [ Br1ght0ne hugoreeves ];
  };
}
