{ lib, stdenvNoCC, fetchFromGitHub, python3, makeBinaryWrapper }:

stdenvNoCC.mkDerivation rec {
  pname = "extism-cli";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "extism";
    repo = "cli";
    rev = "97935786166e82154266b82410028482800e6061";
    sha256 = "sha256-LRzXuZQt5h3exw43UXUwLVIhveYVFw/SQ2YtHI9ZnWc=";
  };

  buildInputs = [ python3 ];
  nativeBuildInputs = [ makeBinaryWrapper ];

  installPhase = ''
    runHook preInstall

    install -D -m 755 ./extism_cli/__init__.py "$out/bin/extism"

    # The extism cli tries by default to install a library and header into /usr/local which does not work on NixOS.
    # Pass a reasonable writable directory which can still be overwritten with another --prefix argument.
    wrapProgram "$out/bin/extism" \
      --add-flags '--prefix $HOME/.local'

    runHook postInstall
  '';

  meta = with lib; {
    description = "The extism CLI is used to manage Extism installations";
    homepage = "https://github.com/extism/cli";
    license = licenses.bsd3;
    maintainers = with maintainers; [ borlaag ];
    platforms = platforms.all;
  };
}
