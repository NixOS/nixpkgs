{ lib, stdenv, buildGoModule, fetchFromGitHub, openssh, makeWrapper }:

buildGoModule rec {
  pname = "assh";
  version = "2.11.0";

  src = fetchFromGitHub {
    repo = "advanced-ssh-config";
    owner = "moul";
    rev = "v${version}";
    sha256 = "sha256-/StB5yee9sbkebuJt6JDI+bp52NG0bBhprzmdepL+ek=";
  };

  vendorSha256 = "sha256-6OAsO7zWAgPfQWD9k+nYH7hnDDUlKIjTB61ivvoubn0=";

  doCheck = false;

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram "$out/bin/assh" \
      --prefix PATH : ${openssh}/bin
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/assh --help > /dev/null
  '';

  meta = with lib; {
    description = "Advanced SSH config - Regex, aliases, gateways, includes and dynamic hosts";
    homepage = "https://github.com/moul/assh";
    changelog = "https://github.com/moul/assh/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ zzamboni ];
    platforms = with platforms; linux ++ darwin;
  };
}
