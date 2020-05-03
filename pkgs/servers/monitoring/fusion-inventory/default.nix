{ stdenv, lib, fetchurl, perlPackages, nix, dmidecode, pciutils, usbutils, iproute, nettools
, fetchFromGitHub, makeWrapper
}:

perlPackages.buildPerlPackage rec {
  pname = "FusionInventory-Agent";
  version = "2.3.21";

  src = fetchFromGitHub {
    owner = "fusioninventory";
    repo = "fusioninventory-agent";
    rev = version;
    sha256 = "034clffcn0agx85macjgml4lyhvvck7idn94pqd2c77pk6crvw2y";
  };

  patches = [
    ./remove_software_test.patch
    # support for os-release file
    (fetchurl {
      url = "https://github.com/fusioninventory/fusioninventory-agent/pull/396.diff";
      sha256 = "0bxrjmff80ab01n23xggci32ajsah6zvcmz5x4hj6ayy6dzwi6jb";
    })
    # support for Nix software inventory
    (fetchurl {
      url = "https://github.com/fusioninventory/fusioninventory-agent/pull/397.diff";
      sha256 = "0pyf7mp0zsb3zcqb6yysr1zfp54p9ciwjn1pzayw6s9flmcgrmbw";
    })
    ];

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
