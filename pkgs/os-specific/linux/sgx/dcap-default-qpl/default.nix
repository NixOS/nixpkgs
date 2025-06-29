{
  stdenv,
  fetchFromGitHub,

  lib,
  pkg-config,
  curl,
  openssl,
  boost,
  sgx-sdk,
}:
stdenv.mkDerivation rec {
  pname = "sgx-dcap-default-qpl";
  version = "1.21";
  src = fetchFromGitHub {
    owner = "intel";
    repo = "SGXDataCenterAttestationPrimitives";
    rev = "dcap_${version}_reproducible";
    hash = "sha256-2ZMu9F46yR4KmTV8Os3fcjgF1uoXxBT50aLx72Ri/WY=";
    fetchSubmodules = true;
  };
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    curl
    openssl
    boost
    sgx-sdk
  ];
  outputs = [ "out" ];
  preBuild = ''
    source ${sgx-sdk}/sgxsdk/environment
  '';
  makeFlags = [
    "-C QuoteGeneration"
    "qpl_wrapper"
  ];
  installPhase = ''
    mkdir -p $out/lib
    mv QuoteGeneration/build/linux/* $out/lib
    ln -s $out/lib/libdcap_quoteprov.so $out/lib/libdcap_quoteprov.so.1
    ln -s $out/lib/libsgx_default_qcnl_wrapper.so $out/lib/libsgx_default_qcnl_wrapper.so.1
  '';

  meta = {
    description = "Intel(R) Software Guard Extensions Data Center Attestation Primitives (Intel(R) SGX DCAP) Quote Generation Library";
    homepage = "https://github.com/intel/SGXDataCenterAttestationPrimitives";
    maintainers = [ lib.maintainers.ozwaldorf ];
    platforms = [ "x86_64-linux" ];
    license = [ lib.licenses.bsd3 ];
  };
}
