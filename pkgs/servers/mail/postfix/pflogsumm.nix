{ stdenv, fetchurl, buildPerlPackage, perlPackages
}:

buildPerlPackage rec {
  name = "pflogsumm-${version}";
  version = "1.1.3";

  src = fetchurl {
    url = "http://jimsun.linxnet.com/downloads/${name}.tar.gz";
    sha256 = "0hkim9s5f1yg5sfs5048jydhy3sbxafls496wcjk0cggxb113py4";
  };

  outputs = [ "out" "man" ];
  buildInputs = [ perlPackages.DateCalc ];

  preConfigure = ''
    touch Makefile.PL
  '';
  doCheck = false;

  installPhase = ''
    mkdir -p "$out/bin"
    mv "pflogsumm.pl" "$out/bin/pflogsumm"

    mkdir -p "$out/share/man/man1"
    mv "pflogsumm.1" "$out/share/man/man1"
  '';

  meta = {
    homepage = "http://jimsun.linxnet.com/postfix_contrib.html";
    description = "Postfix activity overview";
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
