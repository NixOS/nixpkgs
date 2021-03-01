{ lib, stdenv, fetchurl, pkg-config, libseccomp, util-linux, qemu }:

let version = "0.6.8";
in stdenv.mkDerivation {
  pname = "solo5";
  inherit version;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = lib.optional (stdenv.hostPlatform.isLinux) libseccomp;

  src = fetchurl {
    url =
      "https://github.com/Solo5/solo5/releases/download/v${version}/solo5-v${version}.tar.gz";
    sha256 = "sha256-zrxNCXJIuEbtE3YNRK8Bxu2koHsQkcF+xItoIyhj9Uc=";
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
  checkInputs = [ util-linux qemu ];
  checkPhase = if stdenv.hostPlatform.isLinux then
    ''
    patchShebangs tests
    ./tests/bats-core/bats ./tests/tests.bats
    ''
  else
    null;

  meta = with lib; {
    description = "Sandboxed execution environment";
    homepage = "https://github.com/solo5/solo5";
    license = licenses.isc;
    maintainers = [ maintainers.ehmry ];
    platforms = builtins.map ({arch, os}: "${arch}-${os}")
      (cartesianProductOfSets {
        arch = [ "aarch64" "x86_64" ];
        os = [ "freebsd" "genode" "linux" "openbsd" ];
      });
  };

}
