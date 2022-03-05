{ stdenv
, lib
, fetchurl
, cmake
, coreutils
, curl
, file
, glibc
, makeWrapper
, nixosTests
, protobuf
, python3
, sgx-sdk
, shadow
, systemd
, util-linux
, which
, debug ? false
}:
stdenv.mkDerivation rec {
  inherit (sgx-sdk) version versionTag src;
  pname = "sgx-psw";

  postUnpack =
    let
      ae.prebuilt = fetchurl {
        url = "https://download.01.org/intel-sgx/sgx-linux/${versionTag}/prebuilt_ae_${versionTag}.tar.gz";
        hash = "sha256-JriA9UGYFkAPuCtRizk8RMM1YOYGR/eO9ILnx47A40s=";
      };
      dcap = rec {
        version = "1.12.1";
        filename = "prebuilt_dcap_${version}.tar.gz";
        prebuilt = fetchurl {
          url = "https://download.01.org/intel-sgx/sgx-dcap/${version}/linux/${filename}";
          hash = "sha256-V/XHva9Sq3P36xSW+Sd0G6Dnk4H0ANO1Ns/u+FI1eGI=";
        };
      };
    in
    sgx-sdk.postUnpack + ''
      # Make sure we use the correct version of prebuilt DCAP
      grep -q 'ae_file_name=${dcap.filename}' "$src/external/dcap_source/QuoteGeneration/download_prebuilt.sh" \
        || (echo "Could not find expected prebuilt DCAP ${dcap.filename} in linux-sgx source" >&2 && exit 1)

      tar -zxf ${ae.prebuilt}   -C $sourceRoot/
      tar -zxf ${dcap.prebuilt} -C $sourceRoot/external/dcap_source/QuoteGeneration/
    '';

  nativeBuildInputs = [
    cmake
    file
    makeWrapper
    python3
    sgx-sdk
    which
  ];

  buildInputs = [
    curl
    protobuf
  ];

  hardeningDisable = lib.optionals debug [
    "fortify"
  ];

  postPatch = ''
    # https://github.com/intel/linux-sgx/pull/730
    substituteInPlace buildenv.mk --replace '/bin/cp' 'cp'
    substituteInPlace psw/ae/aesm_service/source/CMakeLists.txt \
      --replace '/usr/bin/getconf' 'getconf'

    # https://github.com/intel/SGXDataCenterAttestationPrimitives/pull/205
    substituteInPlace ./external/dcap_source/QuoteGeneration/buildenv.mk \
      --replace '/bin/cp' 'cp'
    substituteInPlace external/dcap_source/tools/SGXPlatformRegistration/Makefile \
      --replace '/bin/cp' 'cp'
    substituteInPlace external/dcap_source/tools/SGXPlatformRegistration/buildenv.mk \
      --replace '/bin/cp' 'cp'

    patchShebangs \
      linux/installer/bin/build-installpkg.sh \
      linux/installer/common/psw/createTarball.sh \
      linux/installer/common/psw/install.sh
  '';

  dontUseCmakeConfigure = true;

  # Randomly fails if enabled
  enableParallelBuilding = false;

  buildFlags = [
    "psw_install_pkg"
  ] ++ lib.optionals debug [
    "DEBUG=1"
  ];

  installFlags = [
    "-C linux/installer/common/psw/output"
    "DESTDIR=$(TMPDIR)/install"
  ];

  postInstall = ''
    installDir=$TMPDIR/install
    sgxPswDir=$installDir/opt/intel/sgxpsw

    mv $installDir/usr/lib64/ $out/lib/
    ln -sr $out/lib $out/lib64

    # Install udev rules to lib/udev/rules.d
    mv $sgxPswDir/udev/ $out/lib/

    # Install example AESM config
    mkdir $out/etc/
    mv $sgxPswDir/aesm/conf/aesmd.conf $out/etc/
    rmdir $sgxPswDir/aesm/conf/

    # Delete init service
    rm $sgxPswDir/aesm/aesmd.conf

    # Move systemd services
    mkdir -p $out/lib/systemd/system/
    mv $sgxPswDir/aesm/aesmd.service $out/lib/systemd/system/
    mv $sgxPswDir/remount-dev-exec.service $out/lib/systemd/system/

    # Move misc files
    mkdir $out/share/
    mv $sgxPswDir/licenses $out/share/

    # Remove unnecessary files
    rm $sgxPswDir/{cleanup.sh,startup.sh}
    rm -r $sgxPswDir/scripts

    mv $sgxPswDir/aesm/ $out/

    mkdir $out/bin
    makeWrapper $out/aesm/aesm_service $out/bin/aesm_service \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ protobuf ]}:$out/aesm \
      --run "cd $out/aesm"

    # Make sure we didn't forget to handle any files
    rmdir $sgxPswDir || (echo "Error: The directory $installDir still contains unhandled files: $(ls -A $installDir)" >&2 && exit 1)
  '';

  # Most—if not all—of those fixups are not relevant for NixOS as we have our own
  # NixOS module which is based on those files without relying on them. Still, it
  # is helpful to have properly patched versions for non-NixOS distributions.
  postFixup = ''
    header "Fixing aesmd.service"
    substituteInPlace $out/lib/systemd/system/aesmd.service \
      --replace '@aesm_folder@' \
                "$out/aesm" \
      --replace 'Type=forking' \
                'Type=simple' \
      --replace "ExecStart=$out/aesm/aesm_service" \
                "ExecStart=$out/bin/aesm_service --no-daemon"\
      --replace "/bin/mkdir" \
                "${coreutils}/bin/mkdir" \
      --replace "/bin/chown" \
                "${coreutils}/bin/chown" \
      --replace "/bin/chmod" \
                "${coreutils}/bin/chmod" \
      --replace "/bin/kill" \
                "${coreutils}/bin/kill"

    header "Fixing remount-dev-exec.service"
    substituteInPlace $out/lib/systemd/system/remount-dev-exec.service \
      --replace '/bin/mount' \
                "${util-linux}/bin/mount"

    header "Fixing linksgx.sh"
    # https://github.com/intel/linux-sgx/pull/736
    substituteInPlace $out/aesm/linksgx.sh \
      --replace '/usr/bin/getent' \
                '${glibc.bin}/bin/getent' \
      --replace '/usr/sbin/usermod' \
                '${shadow}/bin/usermod'
  '';

  passthru.tests = {
    service = nixosTests.aesmd;
  };

  meta = with lib; {
    description = "Intel SGX Architectural Enclave Service Manager";
    homepage = "https://github.com/intel/linux-sgx";
    maintainers = with maintainers; [ veehaitch citadelcore ];
    platforms = [ "x86_64-linux" ];
    license = with licenses; [ bsd3 ];
  };
}
