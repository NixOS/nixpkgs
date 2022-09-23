{ fetchFromGitLab, installShellFiles, lib, python3, stdenv }:

stdenv.mkDerivation rec {
  pname = "nvd";
  version = "0.1.2";

  src = fetchFromGitLab {
    owner = "khumba";
    repo = pname;
    # There is a 0.1.2 release but no tag yet
    # https://gitlab.com/khumba/nvd/-/issues/7
    rev = "13d3ab1255e0de03693cecb7da9764c9afd5d472";
    sha256 = "1537s7j0m0hkahf0s1ai7bm94xj9fz6b9x78py0dn3cgnl9bfzla";
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
