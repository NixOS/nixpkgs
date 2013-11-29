args: with args;
rec {
  name = "texlive-extra_2013.20131112";

  src = fetchurl {
    url    = "mirror://debian/pool/main/t/texlive-extra/texlive-extra/${name}.orig.tar.xz";
    sha256 = "0qpiig9sz8wx3dhy1jha7rkxrhvpf2cmfx424h68s3ql05nnw65i";
  };

  buildInputs = [ texLive xz ];

  phaseNames = [ "doCopy" ];

  doCopy = fullDepEntry (''
    mkdir -p $out/share
    cp -r texmf* $out/
    ln -s $out/texmf* $out/share
  '') [ "minInit" "doUnpack" "defEnsureDir" "addInputs" ];

  meta = with stdenv.lib; {
    description = "Extra components for TeXLive";
    license     = licenses.publicDomain;
    maintainers = with maintainers; [ lovek323 raskin ];
    platforms   = platforms.all;
  };
}
