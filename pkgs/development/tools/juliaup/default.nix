{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "juliaup";
  version = "1.6.12";

  src = fetchFromGitHub {
    owner = "JuliaLang";
    repo = "juliaup";
    rev = "v${version}";
    sha256 = "sha256-nOhOLB79Cz+78sgK7c6pIpwMXfeWSoB+9MmNvfrtGsw=";
  };

  cargoSha256 = "sha256-u2yWr4CEq62nK2Bfdwj/zON2xMGdvN87Dz5HklDOfZw=";
  verifyCargoDeps = true;

  buildFeatures = [ "selfupdate" ];
  
  # Needs internet
  doCheck = false;

  meta = with lib; {
    description = "Julia installer and version multiplexer";
    homepage = "https://github.com/JuliaLang/juliaup";
    license = licenses.mit;
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.unix;
  };
}
