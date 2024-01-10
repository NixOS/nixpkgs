{ rustPlatform, fetchFromGitHub, lib }:

rustPlatform.buildRustPackage rec {
  pname = "pipes-rs";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "lhvy";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-PUCbirnOPYIqt56IF6UQ7Jd0bJLsVY2pGIn/C95HTrQ=";
  };

  cargoHash = "sha256-6OTiciRqZyuX4FaDg131DEaVssUT2OYXdw/cxxJmLso=";

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
    license = licenses.blueOak100;
    maintainers = [ maintainers.vanilla ];
  };
}
