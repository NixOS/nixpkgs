{ rustPlatform, fetchFromGitHub, lib }:

rustPlatform.buildRustPackage rec {
  pname = "pipes-rs";
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "lhvy";
    repo = pname;
    rev = "v${version}";
    sha256 = "drqoKkju1EkcWGNnliEah37wVhtU2ddJSOZ5MnCNbuo=";
  };

  cargoSha256 = "0j6b5697ichw4ly7lsj3nbm0mw6bvjma81nd0fl7v1ra9kbmsysk";

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
