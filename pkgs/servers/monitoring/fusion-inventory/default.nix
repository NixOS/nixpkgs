{ stdenv, fetchurl, buildPerlPackage, perlPackages
}:

buildPerlPackage rec {
  version = "2.3.18";
  name = "FusionInventory-Agent-${version}";
  src = fetchurl {
    url = "mirror://cpan/authors/id/G/GR/GROUSSE/${name}.tar.gz";
    sha256 = "543d96fa61b8f2a2bc599fe9f694f19d1f2094dc5506bc514d00b8a445bc5401";
  };

  patches = [ ./remove_software_test.patch ];

  postPatch = ''
    patchShebangs bin
  '';

  buildTools = [];
  buildInputs = with perlPackages; [
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
    NetSNMP
    TestCompile
    TestDeep
    TestException
    TestMockModule
    TestMockObject
    TestNoWarnings
  ];
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
      sed -e "s|./lib|$out/lib|" -i "$cur"
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
