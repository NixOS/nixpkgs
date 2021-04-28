{ lib, stdenv, fetchurl, pkg-config, libseccomp, util-linux, qemu }:

let
  version = "0.6.8";
  # list of all theoretically available targets
  targets = [
    "genode"
    "hvt"
    "muen"
    "spt"
    "virtio"
    "xen"
  ];
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

    # get CONFIG_* vars from Makeconf which also parse in sh
    grep '^CONFIG_' Makeconf > nix_tmp_targetconf
    source nix_tmp_targetconf
    # install opam / pkg-config files for all enabled targets
    ${lib.concatMapStrings (bind: ''
      [ -n "$CONFIG_${lib.toUpper bind}" ] && make install-opam-${bind}
    '') targets}

    runHook postInstall
  '';

  doCheck = stdenv.hostPlatform.isLinux;
  checkInputs = [ util-linux qemu ];
  checkPhase = ''
    runHook preCheck
    patchShebangs tests
    ./tests/bats-core/bats ./tests/tests.bats
    runHook postCheck
  '';

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
