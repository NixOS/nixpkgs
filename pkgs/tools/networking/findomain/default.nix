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
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "Edu4rdSHL";
    repo = pname;
    rev = version;
    sha256 = "1p7bj8q3zwn92nn6d71bk7cczclcsjvan6m8znlzr4lrwircp1y1";
  };

  cargoSha256 = "1grb0frc1kp3z6vs2906h9v1yx9qxn6x0gf9jy1msqgnqjw0bgn9";

  nativeBuildInputs = [ installShellFiles perl ];
  buildInputs = lib.optional stdenv.isDarwin Security;

  postInstall = ''
    installManPage ${pname}.1
  '';

  meta = with lib; {
    description = "The fastest and cross-platform subdomain enumerator";
    homepage = "https://github.com/Edu4rdSHL/findomain";
    license = licenses.gpl3;
    maintainers = with maintainers; [ filalex77 ];
    platforms = platforms.all;
  };
}
