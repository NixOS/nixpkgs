args: with args;
stdenv.mkDerivation {
  name = "aMule-2.1.3";

  src = 
	fetchurl {
		url = mirror://sourceforge/amule/aMule-2.1.3.tar.bz2;
		sha256 = "0i027g8sc865c9hgrnz9syy3j0pcl84sa89vbsvk3hkspd3yk5vf";
	};

  buildInputs =[zlib wxGTK];

  meta = {
    description = "
	EDonkey client.
";
  };
}
