{ fetchFromGitLab, installShellFiles, lib, python3, stdenv }:

stdenv.mkDerivation rec {
  pname = "nvd";
  version = "0.2.3";

  src = fetchFromGitLab {
    owner = "khumba";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256:005nh24j01s0hd5j0g0qp67wpivpjwryxyyh6y44jijb4arrfrjf";
  };

  buildInputs = [ python3 ];

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    runHook preInstall
    install -m555 -Dt $out/bin src/nvd
    installManPage src/nvd.1
    runHook postInstall
  '';

  meta = with lib; {
    description = "Nix/NixOS package version diff tool";
    homepage = "https://gitlab.com/khumba/nvd";
    license = licenses.asl20;
    maintainers = with maintainers; [ khumba ];
    platforms = platforms.all;
  };
}
