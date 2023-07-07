{ rustPlatform, fetchFromGitHub, lib }:

rustPlatform.buildRustPackage rec {
  pname = "pipes-rs";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "lhvy";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-0i5jAqOGq+N5bUM103Gk1Wzgwe7wUQRjJ+T4XqUkuZw=";
  };

  cargoHash = "sha256-LOU1BCFeX+F2dJdajgLDAtgyyrn6KkvLx3KtF9NkKcY=";

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
