{ stdenv, fetchFromGitHub, fetchpatch, automake, autoconf, libtool
, zimlib, cxxtools, tntnet
}:

stdenv.mkDerivation {
  name = "zimreader-0.92";

  src = fetchFromGitHub {
    owner = "wikimedia";
    repo = "openzim";
    rev = "r1.3"; # there multiple tools with different version in the repo
    sha256 = "0x529137rxy6ld64xqa6xmn93121ripxvkf3sc7hv3wg6km182sw";
  };

  patchFlags = [ "-p2" ];
  patches = [
    (fetchpatch {
      name = "zimreader_tntnet221.patch";
      url = "https://github.com/wikimedia/openzim/compare/r1.3...juliendehos:3ee5f11eaa811284d340451e6f466529c00f6ef2.patch";
      sha256 = "0rc5n20svyyndqh7hsynjyblfraphgi0f6khw6f5jq89w9i1j1hd";
    })
  ];

  enableParallelBuilding = true;
  buildInputs = [ automake autoconf libtool zimlib cxxtools tntnet ];
  setSourceRoot = ''
    sourceRoot=$(echo */zimreader)
  '';
  preConfigure = "./autogen.sh";

  meta = {
    description = "A tool to serve ZIM files using HTTP";
    homepage = http://git.wikimedia.org/log/openzim;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ robbinch juliendehos ];
    platforms = [ "x86_64-linux" ];
  };
}
