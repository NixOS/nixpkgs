{stdenv, fetchurl, perl, perlXMLSimple}:

stdenv.mkDerivation {
  name = "icon-naming-utils-0.8.2";
  src = fetchurl {
    url = http://tango-project.org/releases/icon-naming-utils-0.8.2.tar.gz;
    sha256 = "0ml00nrnd7bkdm09wdj592axwg6v6lcb9yvazc540ls8by6kkzl7";
  };
  buildInputs = [perl perlXMLSimple];
  postInstall = "
    # Add XML::Simple to the runtime search path.
    substituteInPlace $out/libexec/icon-name-mapping \\
        --replace '/bin/perl' '/bin/perl -I${perlXMLSimple}/lib/site_perl';
    ensureDir $out/lib
    ln -s $out/share/pkgconfig $out/lib/pkgconfig # WTF?
  ";
}
