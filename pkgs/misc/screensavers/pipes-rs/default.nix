{ rustPlatform, fetchFromGitHub, lib }:

rustPlatform.buildRustPackage rec {
  pname = "pipes-rs";
  version = "1.4.6";

  src = fetchFromGitHub {
    owner = "lhvy";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HtwUYYQqldEtE9VkQAJscW8jp/u8Cb4/G5d2uqanOjI=";
  };

  cargoSha256 = "sha256-o/aPB0jfZfg2sDkgCBlLlCK3gbjjHZeiG8OxRXKXJyY=";

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
