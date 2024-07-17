{
  lib,
  perlPackages,
  nix,
  dmidecode,
  pciutils,
  usbutils,
  iproute2,
  nettools,
  fetchFromGitHub,
  makeWrapper,
}:

perlPackages.buildPerlPackage rec {
  pname = "FusionInventory-Agent";
  version = "2.6";

  src = fetchFromGitHub {
    owner = "fusioninventory";
    repo = "fusioninventory-agent";
    rev = version;
    sha256 = "1hbp5a9m03n6a80xc8z640zs71qhqk4ifafr6fp0vvzzvq097ip2";
  };

  postPatch = ''

    patchShebangs bin

    substituteInPlace "lib/FusionInventory/Agent/Tools/Linux.pm" \
      --replace /sbin/ip ${iproute2}/sbin/ip
    substituteInPlace "lib/FusionInventory/Agent/Task/Inventory/Linux/Networks.pm" \
      --replace /sbin/ip ${iproute2}/sbin/ip
  '';

  buildTools = [ ];
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = (
    with perlPackages;
    [
      CGI
      DataStructureUtil
      FileCopyRecursive
      HTTPProxy
      HTTPServerSimple
      HTTPServerSimpleAuthen
      IOCapture
      IOSocketSSL
      IPCRun
      JSON
      LWPProtocolHttps
      ModuleInstall
      NetSNMP
      TestCompile
      TestDeep
      TestException
      TestMockModule
      TestMockObject
      TestNoWarnings
    ]
  );
  propagatedBuildInputs = with perlPackages; [
    FileWhich
    LWP
    NetIP
    TextTemplate
    UNIVERSALrequire
    XMLTreePP
  ];

  # Test fails due to "Argument list too long"
  doCheck = false;

  installPhase = ''
    mkdir -p $out

    cp -r bin $out
    cp -r lib $out
    cp -r share $out

    for cur in $out/bin/*; do
      if [ -x "$cur" ]; then
        sed -e "s|./lib|$out/lib|" -i "$cur"
        wrapProgram "$cur" --prefix PATH : ${
          lib.makeBinPath [
            nix
            dmidecode
            pciutils
            usbutils
            nettools
            iproute2
          ]
        }
      fi
    done
  '';

  outputs = [ "out" ];

  meta = with lib; {
    homepage = "http://www.fusioninventory.org";
    description = "FusionInventory unified Agent for UNIX, Linux, Windows and MacOSX";
    license = lib.licenses.gpl2;
    maintainers = [ maintainers.phile314 ];
  };
}
