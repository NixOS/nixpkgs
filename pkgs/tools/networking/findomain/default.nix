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
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "Edu4rdSHL";
    repo = pname;
    rev = version;
    sha256 = "112w4x79zywy6i5vfr04057p9vschflhdhs7b2mhkcba5gigkrxx";
  };

  cargoSha256 = "1bfbg5fzwp8drm0vp16503qd5mgjfw7z9p292xgdx0i20s4wfrkk";

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
