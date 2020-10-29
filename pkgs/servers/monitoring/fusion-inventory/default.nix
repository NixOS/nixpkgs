{ stdenv, lib, fetchurl, perlPackages, nix, dmidecode, pciutils, usbutils, iproute, nettools
, fetchFromGitHub, makeWrapper
}:

perlPackages.buildPerlPackage rec {
  pname = "FusionInventory-Agent";
  version = "2.5.2";

  src = fetchFromGitHub {
    owner = "fusioninventory";
    repo = "fusioninventory-agent";
    rev = version;
    sha256 = "12grxf56kha71p9rd4p6kfp247c91skv5l82ckjyis7lz3m2dsqc";
  };

  postPatch = ''

    patchShebangs bin

    substituteInPlace "lib/FusionInventory/Agent/Tools/Linux.pm" \
      --replace /sbin/ip ${iproute}/sbin/ip
    substituteInPlace "lib/FusionInventory/Agent/Task/Inventory/Linux/Networks.pm" \
      --replace /sbin/ip ${iproute}/sbin/ip
  '';

  buildTools = [];
  buildInputs = [ makeWrapper ] ++ (with perlPackages; [
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
  ]);
  propagatedBuildInputs = with perlPackages; [
    FileWhich
    LWP
    NetIP
    TextTemplate
    UNIVERSALrequire
    XMLTreePP
  ];

  doCheck = false;

  installPhase = ''
    mkdir -p $out

    cp -r bin $out
    cp -r lib $out

    for cur in $out/bin/*; do
      if [ -x "$cur" ]; then
        sed -e "s|./lib|$out/lib|" -i "$cur"
        wrapProgram "$cur" --prefix PATH : ${lib.makeBinPath [nix dmidecode pciutils usbutils nettools iproute]}
      fi
    done
  '';

  outputs = [ "out" ];

  meta = with stdenv.lib; {
    homepage = "http://www.fusioninventory.org";
    description = "FusionInventory unified Agent for UNIX, Linux, Windows and MacOSX";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ maintainers.phile314 ];
  };
}
