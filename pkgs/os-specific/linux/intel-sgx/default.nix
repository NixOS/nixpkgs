{ type, debug ? false }:
assert builtins.elem type [ "sdk" "psw" ];

{ lib
, pkgs
, cmake
, stdenv
, fetchurl
, fetchFromGitHub
, coreutils
, autoconf
, automake
, libtool
, curl
, ocaml
, ocamlPackages
, which
, file
, git
, getconf
, gnum4
, openssl
, perl
, protobuf
, texinfo
, bison
, flex
}:
let
  sgx = rec {
    version = "2.13";
    prebuiltUrl = "https://download.01.org/intel-sgx/sgx-linux/${version}";
  };

  dcap = rec {
    version = "1.10";
    prebuiltUrl = "https://download.01.org/intel-sgx/sgx-dcap/${version}/linux";
  };

  prebuilt = {
    optlib = fetchurl {
      url = "${sgx.prebuiltUrl}/optimized_libs_${sgx.version}.tar.gz";
      sha256 = "sha256-ok/UKBR6//uGAww0dD6MuVMvfUhH5E6F/Z5DAx1PA1k=";
    };

    binutils = fetchurl {
      url = "${sgx.prebuiltUrl}/as.ld.objdump.gold.r3.tar.gz";
      sha256 = "sha256-eUljypD7BWHK8+0r7h2bo5QibzVWic3aKBYebgYgpxM=";
    };

    ae = fetchurl {
      url = "${sgx.prebuiltUrl}/prebuilt_ae_${sgx.version}.tar.gz";
      sha256 = "sha256-ggxxP2tFMbe6R1/bKI1hZkcnfVqxYBmYxtxQ12G4hp4=";
    };

    dcap = fetchurl {
      url = "${dcap.prebuiltUrl}/prebuilt_dcap_${dcap.version}.tar.gz";
      sha256 = "sha256-lT5oEKWLyV987ifFyC3QfwP0POLNInUAwsPyPZHaWgA=";
    };
  };
in
stdenv.mkDerivation {
  inherit (sgx) version;
  pname = "intel-sgx-${type}";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "linux-sgx";
    rev = "sgx_${sgx.version}";
    sha256 = "0iifafkh2hw2vy6ch50m5p0gk4nnmkppsc54ss61bhw09w6cfj1l";
    fetchSubmodules = true;
  };

  postUnpack = ''
    tar -zxf ${prebuilt.optlib} -C $sourceRoot
    tar -zxf ${prebuilt.binutils} -C $sourceRoot
    tar -zxf ${prebuilt.ae} -C $sourceRoot
    tar -zxf ${prebuilt.dcap} -C $sourceRoot/external/dcap_source/QuoteGeneration/
  '';

  postPatch = ''
    SGX_VERSION=$(awk '/STRFILEVER/ {print $3}' common/inc/internal/se_version.h|sed 's/^\"\(.*\)\"$/\1/')

    substituteInPlace buildenv.mk \
        --replace /bin/cp ${coreutils}/bin/cp
    substituteInPlace external/dcap_source/QuoteGeneration/buildenv.mk \
        --replace /bin/cp ${coreutils}/bin/cp

    substituteInPlace external/openmp/Makefile \
        --replace '$(RM) -rf openmp_code/final/build $(BUILD_DIR)/libsgx_omp.a' 'rm -f $(BUILD_DIR)/libsgx_omp.a' \
        --replace '$(RM) -rf openmp_code' 'echo >/dev/null' \
        --replace 'git clone' 'true || git clone'

    substituteInPlace psw/ae/aesm_service/source/CMakeLists.txt \
        --replace '/usr/bin/getconf' '${getconf}/bin/getconf'
    
    for i in linux/installer/common/sdk/pkgconfig/template/*.pc; do
      substituteInPlace $i \
        --replace /opt/intel/sgxsdk $out/usr/share/sgxsdk \
        --replace @LIB_FOLDER_NAME@ lib64 \
        --replace @SGX_VERSION@ $SGX_VERSION
    done
  '';

  installPhase =
    let build = "build/linux";
    in
    if type == "sdk" then ''
      # copy headers
      mkdir -p $out/include
      cp -r common/inc/* $out/include/
      cp psw/enclave_common/sgx_enclave_common.h $out/include/

      cp external/ippcp_internal/inc/*.h $out/include/

      cp external/dcap_source/QuoteGeneration/quote_wrapper/common/inc/sgx_ql_lib_common.h $out/include/
      cp external/dcap_source/QuoteGeneration/quote_wrapper/common/inc/sgx_quote_3.h $out/include/
      cp external/dcap_source/QuoteGeneration/quote_wrapper/common/inc/sgx_ql_quote.h $out/include/
      cp external/dcap_source/QuoteGeneration/pce_wrapper/inc/sgx_pce.h $out/include/
      cp external/dcap_source/QuoteVerification/QvE/Include/sgx_qve_header.h $out/include/
      cp external/dcap_source/QuoteVerification/dcap_tvl/sgx_dcap_tvl.h $out/include/
      cp external/dcap_source/QuoteVerification/dcap_tvl/sgx_dcap_tvl.edl $out/include/

      cp -r sdk/tlibcxx/include $out/include/libcxx

      # copy sample code
      cp -r SampleCode $out/SampleCode
      mkdir $out/SampleCode/RemoteAttestation/sample_libcrypto
      cp ${build}/libsample_libcrypto.so $out/SampleCode/RemoteAttestation/sample_libcrypto/
      cp sdk/sample_libcrypto/sample_libcrypto.h $out/SampleCode/RemoteAttestation/sample_libcrypto/

      # copy libraries
      mkdir -p $out/lib64
      cp ${build}/libsgx_ptrace.so $out/lib64/
      cp ${build}/libsgx_tcrypto.a $out/lib64/
      cp ${build}/libsgx_tkey_exchange.a $out/lib64/
      cp ${build}/libsgx_trts.a $out/lib64/
      cp ${build}/libsgx_trts_sim.a $out/lib64/
      cp ${build}/libsgx_tservice.a $out/lib64/
      cp ${build}/libsgx_tservice_sim.a $out/lib64/
      cp ${build}/libsgx_tstdc.a $out/lib64/
      cp ${build}/libsgx_tcxx.a $out/lib64/
      cp ${build}/libsgx_tcmalloc.a $out/lib64/
      cp ${build}/libsgx_tswitchless.a $out/lib64/
      cp ${build}/libsgx_uswitchless.a $out/lib64/
      cp ${build}/libsgx_ukey_exchange.a $out/lib64/
      cp ${build}/libsgx_capable.a $out/lib64/
      cp ${build}/libsgx_capable.so $out/lib64/
      cp ${build}/libsgx_uprotected_fs.a $out/lib64/
      cp ${build}/libsgx_tprotected_fs.a $out/lib64/
      cp ${build}/libsgx_pcl.a $out/lib64/
      cp ${build}/libsgx_pclsim.a $out/lib64/
      cp ${build}/libsgx_pthread.a $out/lib64/
      cp ${build}/libsgx_omp.a $out/lib64/

      cp ${build}/libsgx_epid_deploy.so $out/lib64/libsgx_epid.so
      cp ${build}/libsgx_epid_sim.so $out/lib64/
      cp ${build}/libsgx_launch_deploy.so $out/lib64/libsgx_launch.so
      cp ${build}/libsgx_launch_sim.so $out/lib64/
      cp ${build}/libsgx_quote_ex_deploy.so $out/lib64/libsgx_quote_ex.so
      cp ${build}/libsgx_quote_ex_sim.so $out/lib64/
      cp ${build}/libsgx_uae_service_deploy.so $out/lib64/libsgx_uae_service.so
      cp ${build}/libsgx_uae_service_sim.so $out/lib64/
      cp ${build}/libsgx_urts_deploy.so $out/lib64/libsgx_urts.so
      cp ${build}/libsgx_urts_sim.so $out/lib64/libsgx_urts_sim.so

      cp -r ${build}/*.a $out/lib64/
      cp -r ${build}/*.so $out/lib64/

      cp -r ${build}/gdb-sgx-plugin $out/lib64/
      cp external/dcap_source/QuoteGeneration/build/linux/libsgx_dcap_tvl.a $out/lib64/

      mkdir -p $out/lib64/cve_2020_0551_cf
      cp -r build/linuxCF/*.a $out/lib64/cve_2020_0551_cf/
      cp external/dcap_source/QuoteGeneration/build/linuxCF/libsgx_dcap_tvl.a $out/lib64/cve_2020_0551_cf/

      mkdir -p $out/lib64/cve_2020_0551_load
      cp -r build/linuxLOAD/*.a $out/lib64/cve_2020_0551_load/
      cp external/dcap_source/QuoteGeneration/build/linuxLOAD/libsgx_dcap_tvl.a $out/lib64/cve_2020_0551_load/

      # copy pkgconfig
      mkdir -p $out/lib64/pkgconfig
      cp -r linux/installer/common/sdk/pkgconfig/template/*.pc $out/lib64/pkgconfig/

      # copy binaries
      mkdir -p $out/bin
      cp ${build}/sgx_config_cpusvn $out/bin/
      cp ${build}/sgx_edger8r $out/bin/
      cp ${build}/sgx_sign $out/bin/
      cp ${build}/sgx_encrypt $out/bin/
      cp ${build}/gdb-sgx-plugin/sgx-gdb $out/bin/

      # link sdk folder (several tools expect this exact folder structure)
      SDK_DIR=$out/usr/share/sgxsdk
      mkdir -p $SDK_DIR
      cp common/buildenv.mk $SDK_DIR/

      ln -s $out/include $SDK_DIR/include
      ln -s $out/lib64 $SDK_DIR/lib64

      mkdir -p $SDK_DIR/bin
      ln -s $out/bin $SDK_DIR/bin/x86
      ln -s $out/bin $SDK_DIR/bin/x64
    '' else ''
      # copy service binaries
      mkdir -p $out/aesm
      cp ${build}/libipc.so $out/aesm/
      cp ${build}/liboal.so $out/aesm/
      cp ${build}/libutils.so $out/aesm/
      cp ${build}/libdcap_quoteprov.so $out/aesm/
      cp ${build}/libsgx_default_qcnl_wrapper.so $out/aesm/
      cp ${build}/liburts_internal.so $out/aesm/
      cp ${build}/libCppMicroServices.so.4.0.0 $out/aesm/
      cp ${build}/aesm_service $out/aesm/

      # signed binaries
      cp ${build}/le_prod_css.bin $out/aesm/
      cp ${build}/libsgx_le.signed.so $out/aesm/
      cp ${build}/libsgx_pve.signed.so $out/aesm/
      cp ${build}/libsgx_qe.signed.so $out/aesm/
      cp ${build}/libsgx_pce.signed.so $out/aesm/

      cp external/dcap_source/QuoteGeneration/psw/ae/data/prebuilt/libsgx_qe3.signed.so $out/aesm/
      cp external/dcap_source/QuoteGeneration/build/linux/libsgx_pce_logic.so $out/aesm/
      cp external/dcap_source/QuoteGeneration/build/linux/libsgx_qe3_logic.so $out/aesm/

      # copy bundle binaries
      mkdir -p $out/aesm/bundles
      cp ${build}/bundles/libepid_quote_service_bundle.so $out/aesm/bundles/
      cp ${build}/bundles/lible_launch_service_bundle.so $out/aesm/bundles/
      cp ${build}/bundles/liblinux_network_service_bundle.so $out/aesm/bundles/
      cp ${build}/bundles/libpce_service_bundle.so $out/aesm/bundles/
      cp ${build}/bundles/libepid_quote_service_bundle.so $out/aesm/bundles/
      cp ${build}/bundles/libecdsa_quote_service_bundle.so $out/aesm/bundles/
      cp ${build}/bundles/libquote_ex_service_bundle.so $out/aesm/bundles/

      mkdir -p $out/aesm/data
      cp psw/ae/aesm_service/data/white_list_cert_to_be_verify.bin $out/aesm/data/

      # render: copy shared libraries
      mkdir -p $out/lib64
      cp ${build}/libsgx_uae_service.so $out/lib64/
      cp ${build}/libsgx_epid.so $out/lib64/libsgx_epid.so.1
      cp ${build}/libsgx_launch.so $out/lib64/libsgx_launch.so.1
      cp ${build}/libsgx_quote_ex.so $out/lib64/libsgx_quote_ex.so.1
      cp ${build}/libsgx_urts.so $out/lib64/
      cp ${build}/libsgx_enclave_common.so $out/lib64/libsgx_enclave_common.so.1

      # install provided udev rules
      mkdir -p $out/etc/udev/rules.d
      cp linux/installer/common/libsgx-enclave-common/91-sgx-enclave.rules $out/etc/udev/rules.d/
      cp linux/installer/common/sgx-aesm-service/92-sgx-provision.rules $out/etc/udev/rules.d/
    '';

  # PSW "depends on itself" because it needs SDK headers to compile
  buildInputs = [
    curl
    openssl
  ] ++ (lib.optional (type == "psw") pkgs.intel-sgx-sdk);

  nativeBuildInputs = [
    autoconf
    automake
    cmake
    libtool
    ocaml
    ocamlPackages.ocamlbuild
    perl
    protobuf
    which
    file
    git
    gnum4
    texinfo
    bison
    flex
  ];

  makeFlags = [ type ]
    # include the path to the SDK for PSW builds which depend on it
    ++ lib.optional (type == "psw") "SGX_SDK=${pkgs.intel-sgx-sdk}/usr/share/sgxsdk"
    ++ lib.optional debug "DEBUG=1";

  # must disable hardening for debug builds
  hardeningDisable = lib.optional debug "fortify";

  dontUseCmakeConfigure = true;

  meta = with lib; {
    description = "Intel SGX for Linux";
    homepage = "https://01.org/intel-softwareguard-extensions";
    license = licenses.bsd3;
    maintainers = with maintainers; [ citadelcore ];
    platforms = platforms.linux;
  };
}
