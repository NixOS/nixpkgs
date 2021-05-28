{ lib, stdenv, fetchurl, pkgconfig, libseccomp }:

let version = "0.6.7";
in stdenv.mkDerivation {
  pname = "solo5";
  inherit version;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = lib.optional (stdenv.hostPlatform.isLinux) libseccomp;

  src = fetchurl {
    url =
      "https://github.com/Solo5/solo5/releases/download/v${version}/solo5-v${version}.tar.gz";
    sha256 = "05k9adg3440zk5baa6ry8z5dj8d8r8hvzafh2469pdgcnr6h45gr";
  };

  hardeningEnable = [ "pie" ];

  configurePhase = ''
    runHook preConfigure
    sh configure.sh
    runHook postConfigure
  '';

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall
    export DESTDIR=$out
    export PREFIX=$out
    make install-tools
    ${lib.optionalString stdenv.hostPlatform.isLinux "make ${
      (lib.concatMapStringsSep " " (x: "install-opam-${x}") [ "hvt" "spt" ])
    }"}
    runHook postInstall
  '';

  doCheck = true;
  checkPhase = if stdenv.hostPlatform.isLinux then
    ''
    patchShebangs tests
    ./tests/bats-core/bats ./tests/tests.bats
    ''
  else
    null;

  meta = with lib; {
    description = "Sandboxed execution environment.";
    homepage = "https://github.com/solo5/solo5";
    license = licenses.isc;
    maintainers = [ maintainers.ehmry ];
    platforms = lib.crossLists (arch: os: "${arch}-${os}") [
      [ "aarch64" "x86_64" ]
      [ "freebsd" "genode" "linux" "openbsd" ]
    ];
  };

}
