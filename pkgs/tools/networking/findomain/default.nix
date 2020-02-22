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
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "Edu4rdSHL";
    repo = pname;
    rev = version;
    sha256 = "1hqvs6h6cfimg0y6hggnmc0mlddajwmh3h36n160n6imq0lfixka";
  };

  # Delete this on next update; see #79975 for details
  legacyCargoFetcher = true;

  cargoSha256 = "0brkza04b38hcjjmqz4bkd8gj0n0mrh0p7427007f5xlnhj7hrn4";

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
