args:
args.stdenv.mkDerivation {
  # snapshot version does'nt compile
  #name = "swftools-2008-10-13-1554";
  name = "swftools-0.8.1";

  src = args.fetchurl {
    #url = http://www.swftools.org/swftools-2008-10-13-1554.tar.gz;
    #sha256 = "05r2qg8yc6lpj5263jyrdykr2vkq9rlyqxydx0rnfnkqpr7s6931";

    url = http://www.swftools.org/swftools-0.8.1.tar.gz;
    sha256 = "0l75c3ibwd24g9nqghp1rv1dfrlicw87s0rbdnyffjv4izz6gc2l";
  };

  buildInputs =(with args; [zlib 
                            # the following are not needed to compile 0.8.1
                            libjpeg giflib freetype]);

  meta = { 
      description = "collection of SWF manipulation and creation utilities";
      homepage = http://www.swftools.org/about.html;
      license = "GPLv2";
    };
}
