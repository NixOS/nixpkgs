{ lib
, stdenv
, fetchFromGitHub
, installShellFiles
, python3
}:

stdenv.mkDerivation rec {
  pname = "ioztat";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "jimsalterjrs";
    repo = "ioztat";
    rev = "v${version}";
    sha256 = "sha256-8svMijgVxSuquPFO2Q2HeqGLdMkwhiujS1DSxC/LRRk=";
  };

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = [ python3 ];

  prePatch = ''
    patchShebangs .
  '';

  installPhase = ''
    runHook preInstall

    install -vDt $out/bin -m 0555 ioztat

    if [ -f ioztat.8 ]; then
      installManPage ioztat.8
    fi

    runHook postInstall
  '';

  meta = with lib; {
    inherit version;
    inherit (src.meta) homepage;
    description = "A storage load analysis tool for OpenZFS";
    longDescription = ''
      ioztat is a storage load analysis tool for OpenZFS. It provides
      iostat-like statistics at an individual dataset/zvol level.

      The statistics offered are read and write operations per second, read and
      write throughput per second, and the average size of read and write
      operations issued in the current reporting interval. Viewing these
      statistics at the individual dataset level allows system administrators
      to identify storage "hot spots" in larger multi-tenant
      systems -- particularly those with many VMs or containers operating
      essentially independent workloads.
    '';
    license = licenses.bsd2;
    platforms = with platforms; linux ++ freebsd;
    maintainers = with maintainers; [ numinit ];
  };
}
