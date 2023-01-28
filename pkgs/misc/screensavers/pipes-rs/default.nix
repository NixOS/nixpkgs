{ rustPlatform, fetchFromGitHub, lib }:

rustPlatform.buildRustPackage rec {
  pname = "pipes-rs";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "lhvy";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-UwRXErlGtneEtc3UAiREwILQPTRQn1AgxiWDzSCZv/M=";
  };

  cargoSha256 = "sha256-Qyuvg13SnTN1dvxn4Gu4tizmjk4zrEi/iuXTV28fZbQ=";

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
