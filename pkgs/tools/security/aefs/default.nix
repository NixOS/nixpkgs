{stdenv, fetchurl, fuse}:
  
stdenv.mkDerivation {
  name = "aefs-0.3pre279";
  
  src = fetchurl {
    url = http://losser.st-lab.cs.uu.nl/~eelco/dist/aefs-0.3pre279.tar.bz2;
    sha256 = "1gsa55cmhgj124m2laxcxcrgh45rsmp9jwz9wc9q515np9s7h11c";
  };

  buildInputs = [fuse];
}
