{ lib, stdenv, buildPackages, fetchurl, tcl, makeWrapper, autoreconfHook, fetchpatch, substituteAll }:

tcl.mkTclDerivation rec {
  pname = "expect";
  version = "5.45.4";

  src = fetchurl {
    url = "mirror://sourceforge/expect/Expect/${version}/expect${version}.tar.gz";
    sha256 = "0d1cp5hggjl93xwc8h1y6adbnrvpkk0ywkd00inz9ndxn21xm9s9";
  };

  patches = [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/buildroot/buildroot/c05e6aa361a4049eabd8b21eb64a34899ef83fc7/package/expect/0001-enable-cross-compilation.patch";
      sha256 = "1jwx2l1slidvcpahxbyqs942l81jd62rzbxliyd9lwysk38c8b6b";
    })
    (substituteAll {
      src = ./fix-cross-compilation.patch;
      tcl = "${buildPackages.tcl}/bin/tclsh";
    })
  ];

  postPatch = ''
    sed -i "s,/bin/stty,$(type -p stty),g" configure.in
  '';

  nativeBuildInputs = [ autoreconfHook makeWrapper ];

  strictDeps = true;
  hardeningDisable = [ "format" ];

  postInstall = ''
    tclWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ tcl ]})
    ${lib.optionalString stdenv.isDarwin "tclWrapperArgs+=(--prefix DYLD_LIBRARY_PATH : $out/lib/expect${version})"}
  '';

  outputs = [ "out" "dev" ];

  meta = with lib; {
    description = "A tool for automating interactive applications";
    homepage = "https://expect.sourceforge.net/";
    license = licenses.publicDomain;
    platforms = platforms.unix;
    mainProgram = "expect";
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
