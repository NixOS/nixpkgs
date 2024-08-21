{ stdenvNoCC, buildPackages, MacOSX-SDK }:

let self = stdenvNoCC.mkDerivation {
  pname = "libnetwork";
  version = MacOSX-SDK.version;

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp ${MacOSX-SDK}/usr/lib/libnetwork* $out/lib

    runHook postInstall
  '';

  passthru = {
    tbdRewrites = {
      const."/usr/lib/libnetwork.dylib" = "${self}/lib/libnetwork.dylib";
    };
  };
}; in self
