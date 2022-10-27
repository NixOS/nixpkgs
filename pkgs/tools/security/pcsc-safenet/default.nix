{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, dpkg
, gtk2
, openssl
, pcsclite
}:

stdenv.mkDerivation rec {
  pname = "pcsc-safenet";
  version = "10.0.37-0";

  # https://aur.archlinux.org/packages/sac-core/
  src = fetchurl {
    url = "https://storage.spidlas.cz/public/soft/safenet/SafenetAuthenticationClient-core-${version}_amd64.deb";
    sha256 = "1r9739bhal7ramj1rpawaqvik45xbs1c756l1da96din638gzy5l";
  };

  dontBuild = true;
  dontConfigure = true;

  unpackPhase = ''
    dpkg-deb -x $src .
  '';

  buildInputs = [
    gtk2
    openssl
    pcsclite
  ];

  runtimeDependencies = [
    openssl
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  installPhase = ''
    # Set up for pcsc drivers
    mkdir -p pcsc/drivers
    mv usr/share/eToken/drivers/* pcsc/drivers/
    rm -r usr/share/eToken/drivers

    # Move binaries out
    mv usr/bin bin

    # Move UI to bin
    mv usr/share/SAC/SACUIProcess bin/
    rm -r usr/share/SAC

    mkdir $out
    cp -r {bin,etc,lib,pcsc,usr,var} $out/

    cd "$out/lib/"
    ln -sf libeToken.so.10.0.37 libeTPkcs11.so
    ln -sf libeToken.so.10.0.37 libeToken.so.10.0
    ln -sf libeToken.so.10.0.37 libeToken.so.10
    ln -sf libeToken.so.10.0.37 libeToken.so
    ln -sf libcardosTokenEngine.so.10.0.37 libcardosTokenEngine.so.10.0
    ln -sf libcardosTokenEngine.so.10.0.37 libcardosTokenEngine.so.10
    ln -sf libcardosTokenEngine.so.10.0.37 libcardosTokenEngine.so

    cd $out/pcsc/drivers/aks-ifdh.bundle/Contents/Linux/
    ln -sf libAksIfdh.so.10.0 libAksIfdh.so
    ln -sf libAksIfdh.so.10.0 libAksIfdh.so.10

    ln -sf ${lib.getLib openssl}/lib/libcrypto.so $out/lib/libcrypto.so.1.0.0
  '';

  dontAutoPatchelf = true;

  # Patch DYN shared libraries (autoPatchElfHook only patches EXEC | INTERP).
  postFixup = ''
    autoPatchelf "$out"

    runtime_rpath="${lib.makeLibraryPath runtimeDependencies}"

    for mod in $(find "$out" -type f -name '*.so.*'); do
      mod_rpath="$(patchelf --print-rpath "$mod")"
      patchelf --set-rpath "$runtime_rpath:$mod_rpath" "$mod"
    done;
  '';

  meta = with lib; {
    homepage = "https://safenet.gemalto.com/multi-factor-authentication/security-applications/authentication-client-token-management";
    description = "Safenet Authentication Client";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ wldhx ];
  };
}
