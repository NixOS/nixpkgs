{ stdenv, fetchFromGitHub, lib, python3, nixosTests, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "knot-exporter";
  version = "unstable-2020-01-30";

  src = fetchFromGitHub {
    owner = "ghedo";
    repo = "knot_exporter";
    rev = "21dd46b401e0c1aea0b173e19462cdf89e1f444e";
    sha256 = "sha256-4au4lpaq3jcqC2JXdCcf8h+YN8Nmm4eE0kZwA+1rWlc=";
  };

  patches = [
    # Fixes a crash with all metrics enabled. See
    # https://github.com/ghedo/knot_exporter/pull/6 for further context.
    (fetchpatch {
      url = "https://github.com/ghedo/knot_exporter/commit/2317476e080369450ae51a707ccd30d4b89d680f.patch";
      sha256 = "sha256-yEPu8EE1V/draNx9DeMrPj+bMfJRxauweo33dITl4AA=";
    })
  ];

  dontBuild = true;

  nativeBuildInputs = [ python3.pkgs.wrapPython ];
  buildInputs = [ python3 ];

  installPhase = ''
    runHook preInstall

    install -Dm0755 knot_exporter $out/bin/knot_exporter
    patchShebangs $out/bin
    buildPythonPath ${python3.pkgs.prometheus_client}
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
