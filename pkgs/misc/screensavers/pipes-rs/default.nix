{ rustPlatform, fetchFromGitHub, lib }:

rustPlatform.buildRustPackage rec {
  pname = "pipes-rs";
  version = "1.4.7";

  src = fetchFromGitHub {
    owner = "lhvy";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-egjmvvbPmIjccg44F2/TiGrn5HRN5hp8XL0yd0/ctv0=";
  };

  cargoSha256 = "sha256-i9aR0dGNRF37Hhs9vq0wpdZGIVkX7M1SzbpASR5ve+g=";

  doInstallCheck = true;

  installCheckPhase = ''
    if [[ "$("$out/bin/${pname}" --version)" == "${pname} ${version}" ]]; then
      echo '${pname} smoke check passed'
    else
      echo '${pname} smoke check failed'
      return 1
    fi
  '';

  meta = with lib; {
    description = "An over-engineered rewrite of pipes.sh in Rust";
    homepage = "https://github.com/lhvy/pipes-rs";
    license = with licenses; [ asl20 mit ];
    maintainers = [ maintainers.vanilla ];
  };
}
