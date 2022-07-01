{ lib, stdenv, fetchurl, dosfstools, libseccomp, makeWrapper, mtools, parted
, pkg-config, qemu, syslinux, util-linux }:

let
  version = "0.6.9";
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

  nativeBuildInputs = [ makeWrapper pkg-config ];
  buildInputs = lib.optional (stdenv.hostPlatform.isLinux) libseccomp;

  src = fetchurl {
    url = "https://github.com/Solo5/solo5/releases/download/v${version}/solo5-v${version}.tar.gz";
    sha256 = "03lvk9mab3yxrmi73wrvvhykqcydjrsda0wj6aasnjm5lx9jycpr";
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

    substituteInPlace $out/bin/solo5-virtio-mkimage \
      --replace "/usr/lib/syslinux" "${syslinux}/share/syslinux" \
      --replace "/usr/share/syslinux" "${syslinux}/share/syslinux" \
      --replace "cp " "cp --no-preserve=mode "

    wrapProgram $out/bin/solo5-virtio-mkimage \
      --prefix PATH : ${lib.makeBinPath [ dosfstools mtools parted syslinux ]}

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
