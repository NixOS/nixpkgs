{ stdenv
, lib
, buildFHSUserEnv
, fetchurl
, dpkg
, pkg-config
, chrpath
, openssl
, curl
, dbus
, nss
, at-spi2-core
, gtk2
, xorg
, python3Packages
, mc
, hello
, sudo
, firefox-bin
, autoPatchelfHook
}:

let
  warsaw-bin-core = stdenv.mkDerivation rec {
    pname = "warsaw-bin-core";
    version = "2.21.1.13";

    src = fetchurl {
      url = "https://cloud.gastecnologia.com.br/gas/diagnostico/warsaw_setup_64.deb";
      sha256 = "sha256-Xd6MRbR33g6dBaBj9mxdmRIkgOFxM0IaKVSxU0SmyUI=";
    };

    # src = fetchurl {
    #   url = "https://cloud.gastecnologia.com.br/cef/warsaw/install/GBPCEFwr64.deb";
    #   sha256 = "sha256-Ll+Joc6Ayp7EHx89fhNegpIcvat1UKEidHpWH6ulQhI=";
    # };

    nativeBuildInputs = [
      dpkg
      pkg-config
      chrpath
      python3Packages.wrapPython
      autoPatchelfHook
    ];

    buildInputs = [
      openssl
      curl
      dbus
      nss
      at-spi2-core
      gtk2
      python3Packages.python
      mc
      firefox-bin
    ];

    unpackPhase = ''
      dpkg-deb -x ${src} ./
    '';

    installPhase = ''
      echo ---------------
      find -ls | sort
      echo ---------------
      mkdir -p $out
      cp -a etc $out
      cp -a usr/* $out
      cp -a lib $out
      echo ---------------
      find $out -ls | sort
      echo ---------------
    '';

    dontConfigure = true;

    dontBuild = true;

    dontPatchELF = true;
  };

in
# warsaw-bin-core

buildFHSUserEnv {
  name = "warsaw-bin";

  targetPkgs = pkgs: with pkgs; [
    at-spi2-core
    curl
    dbus
    gtk2
    nss
    openssl
    sudo
    warsaw-bin-core
    firefox-bin
    #ping
  ];

  runScript = "bash";

  meta = with lib; {
    description = "Banking security tool developed by GAS Tecnologia";
    homepage = "https://diagnostico.gasantifraud.com";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ romildo ];
  };

}
