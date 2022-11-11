{ lib
, stdenvNoCC
, fetchurl
, rpmextract
}:
stdenvNoCC.mkDerivation rec {
  pname = "perccli";
  version = "7.1910.00";

  src = fetchurl {
    url = "https://dl.dell.com/FOLDER07815522M/1/PERCCLI_${version}_A12_Linux.tar.gz";
    sha256 = "sha256-Gt/kr5schR/IzFmnhXO57gjZpOJ9NSnPX/Sj7zo8Qjk=";
    # Dell seems to block "uncommon" user-agents, such as Nixpkgs's custom one.
    # Sending no user-agent at all seems to be fine though.
    curlOptsList = [ "--user-agent" "" ];
  };

  nativeBuildInputs = [ rpmextract ];

  buildCommand = ''
    tar xf $src
    rpmextract PERCCLI_*_Linux/perccli-*.noarch.rpm
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
