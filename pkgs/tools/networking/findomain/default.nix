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
  version = "2.1.4";

  src = fetchFromGitHub {
    owner = "Edu4rdSHL";
    repo = pname;
    rev = version;
    sha256 = "0g0kw1b18kk9jhvw88hcxc04ccj8k22fdzky7l2dv3r37vndd91w";
  };

  cargoSha256 = "0cmp4w86qnzd2b2w4s3w019857pxysgikkl1g7ldkiylrsm5vlpn";

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
  };
}
