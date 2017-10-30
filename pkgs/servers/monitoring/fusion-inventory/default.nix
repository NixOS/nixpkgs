{ stdenv, lib, fetchurl, buildPerlPackage, perlPackages, gnused, nix, dmidecode, pciutils, usbutils, iproute, nettools
, fetchFromGitHub, makeWrapper
}:

buildPerlPackage rec {
  name = "FusionInventory-Agent-${version}";
  version = "2.3.21";
  src = fetchurl {
    url = "mirror://cpan/authors/id/G/GB/GBOUGARD/${name}.tar.gz";
    sha256 = "0c2ijild03bfw125h2gyaip2mg1jxk72dcanrlx9n6pjh2ay90zh";
  };

  patches = [ ./remove_software_test.patch ];

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
    LWPProtocolhttps
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

  installPhase = ''
    mkdir -p $out

    cp -r bin $out
    cp -r lib $out

    for cur in $out/bin/*; do
      if [ -x "$cur" ]; then
        sed -e "s|./lib|$out/lib|" -i "$cur"
        wrapProgram "$cur" --prefix PATH : ${lib.makeBinPath [nix dmidecode pciutils usbutils nettools]}
      fi
    done
  '';

  outputs = [ "out" ];

  meta = with stdenv.lib; {
    homepage = http://www.fusioninventory.org;
    description = "FusionInventory unified Agent for UNIX, Linux, Windows and MacOSX";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ maintainers.phile314 ];
  };
}
