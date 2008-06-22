args:
args.stdenv.mkDerivation {
  name = "gifsicle-1.52";

  src = args.fetchurl {
    url = http://www.lcdf.org/gifsicle/gifsicle-1.52.tar.gz;
    sha256 = "1fp47grvk46bkj22zixrhgpgs3qbkmijicf3wkjk4y8fsx0idbgk";
  };

  buildInputs =(with args; [xproto libXt libX11]);

  meta = { 
      description = "command-line tool for creating, editing, and getting information about GIF images and animations";
      homepage = http://www.lcdf.org/gifsicle/;
      license = "GPL2";
  };
}
