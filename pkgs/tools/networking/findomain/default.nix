{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, installShellFiles
, perl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "findomain";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "Edu4rdSHL";
    repo = pname;
    rev = version;
    sha256 = "sha256-eM3XTZ/Y0Kk5bdC+xskS/btGEVrC50342YBYJdXAlDg=";
  };

  cargoSha256 = "sha256-B5IKDoFzz+JBJa5HFUz5sEaVqzt3yWQ1IDbVm+lArQY=";

  nativeBuildInputs = [ installShellFiles perl ];
  buildInputs = lib.optional stdenv.isDarwin Security;

  postInstall = ''
    installManPage ${pname}.1
  '';

  meta = with lib; {
    description = "The fastest and cross-platform subdomain enumerator";
    homepage = "https://github.com/Edu4rdSHL/findomain";
    license = licenses.gpl3;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
