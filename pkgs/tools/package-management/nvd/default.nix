{ fetchFromGitLab, installShellFiles, lib, python3, stdenv }:

stdenv.mkDerivation rec {
  pname = "nvd";
  version = "0.1.1";

  src = fetchFromGitLab {
    owner = "khumba";
    repo = pname;
    rev = "v${version}";
    sha256 = "0accq0cw6qsxin1fb2bp2ijgjf9akb9qlivkykpfsgnk5qjafv2n";
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
