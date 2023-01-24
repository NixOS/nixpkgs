{ stdenv, fetchFromGitHub, lib, python3, nixosTests }:

stdenv.mkDerivation rec {
  pname = "knot-exporter";
  version = "unstable-2021-08-21";

  src = fetchFromGitHub {
    owner = "ghedo";
    repo = "knot_exporter";
    rev = "b18eb7db735b50280f0815497475f4c7092a6550";
    sha256 = "sha256-FGzkO/KHDhkM3PA2urNQcrMi3MHADkd0YwAvu1jvfrU=";
  };

  dontBuild = true;

  nativeBuildInputs = [ python3.pkgs.wrapPython ];
  buildInputs = [ python3 ];

  installPhase = ''
    runHook preInstall

    install -Dm0755 knot_exporter $out/bin/knot_exporter
    patchShebangs $out/bin
    buildPythonPath ${python3.pkgs.prometheus-client}
    patchPythonScript $out/bin/knot_exporter

    runHook postInstall
  '';

  passthru.tests = { inherit (nixosTests.prometheus-exporters) knot; };

  meta = with lib; {
    homepage = "https://github.com/ghedo/knot_exporter";
    description = " Prometheus exporter for Knot DNS";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ma27 ];
    platforms = platforms.linux;
  };
}
