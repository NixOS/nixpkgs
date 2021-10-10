{ rustPlatform, fetchFromGitHub, lib }:

rustPlatform.buildRustPackage rec {
  pname = "pipes-rs";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "lhvy";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-BC6QqSZ7siDVSO8oOH7DimTe6RFnCBygmvtPrQgsC/Q=";
  };

  cargoSha256 = "sha256-nctkc2vDE7WXm84g/EkGKc1/ju/Xy9d/nc8NPIVFl58=";

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
