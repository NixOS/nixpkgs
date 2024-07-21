{ autoPatchelfHook
, cups
, dpkg
, fetchurl
, lib
, stdenv
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fflinuxprint";
  version = "1.1.3-4";

  src = fetchurl {
    url = "https://support-fb.fujifilm.com/driver_downloads/fflinuxprint_${finalAttrs.version}_amd64.deb";
    hash = "sha256-Q0qB4gvEWa10KGt6SngVqraxFePxIQ62nTrFZ44vyrU=";
    curlOpts = "--user-agent Mozilla/5.0"; # HTTP 410 otherwise
  };

  sourceRoot = ".";
  unpackCmd = "dpkg-deb -x $curSrc .";

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  buildInputs = [
    cups
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/cups/model
    mv {etc,usr/lib} $out
    mv usr/share/ppd/fujifilm/* $out/share/cups/model

    runHook postInstall
  '';

  meta = {
    description = "FujiFILM Linux Printer Driver";
    homepage = "https://support-fb.fujifilm.com";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ jaduff ];
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
