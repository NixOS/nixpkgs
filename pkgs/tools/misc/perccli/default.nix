{ lib
, stdenvNoCC
, fetchurl
, rpmextract
}:

stdenvNoCC.mkDerivation rec {
  pname = "perccli";
  version = "7.2110.00";

  src = fetchurl {
    # On pkg update: manually adjust the version in the URL because of the different format.
    url = "https://dl.dell.com/FOLDER09074160M/1/PERCCLI_7.211.0_Linux.tar.gz";
    sha256 = "sha256-FQasejMVm80uliXOg/riGGwcsK0fSDGh1KYz9r34wBQ=";

    # Dell seems to block "uncommon" user-agents, such as Nixpkgs's custom one.
    # Sending no user-agent at all seems to be fine though.
    curlOptsList = [ "--user-agent" "" ];
  };

  nativeBuildInputs = [ rpmextract ];

  buildCommand = ''
    tar xf $src
    rpmextract perccli-00${version}00.0000-1.noarch.rpm
    install -D ./opt/MegaRAID/perccli/perccli64 $out/bin/perccli64
    ln -s perccli64 $out/bin/perccli

    # Not needed because the binary is statically linked
    #eval fixupPhase
  '';

  meta = with lib; {
    description = "Perccli Support for PERC RAID controllers";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ panicgh ];
    platforms = with platforms; intersectLists x86_64 linux;
  };
}
