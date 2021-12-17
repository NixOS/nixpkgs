{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "pet";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "knqyf263";
    repo = "pet";
    rev = "v${version}";
    sha256 = "sha256-gVTpzmXekQxGMucDKskGi+e+34nJwwsXwvQTjRO6Gdg=";
  };

  vendorSha256 = "sha256-vciiBzmqUAt5ZWn9go4B1uaz0HsBk5Z9Rbw7/MAimY4=";

  doCheck = false;

  subPackages = [ "." ];

  meta = with lib; {
    description = "Simple command-line snippet manager, written in Go";
    homepage = "https://github.com/knqyf263/pet";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
