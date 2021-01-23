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
  version = "2.1.5";

  src = fetchFromGitHub {
    owner = "Edu4rdSHL";
    repo = pname;
    rev = version;
    sha256 = "sha256-sGco8ISbm3C8w6FsF5oq7G09WBBTO9cVeoFnuKauMWQ=";
  };

  cargoSha256 = "sha256-X7us7mLtOSST5LazxSkej9D2ezEk9GiWdudqy4peSJ8=";

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
