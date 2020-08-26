{ stdenv, fetchFromGitHub, fuse, icu, pkgconfig, libxml2, libuuid }:

stdenv.mkDerivation rec {
  version = "3.4.2_Z7550-02501";
  pname = "hpe-ltfs";

  src = fetchFromGitHub {
    rev = version;
    owner = "nix-community";
    repo = "hpe-ltfs";
    sha256 = "193593hsc8nf5dn1fkxhzs1z4fpjh64hdkc8q6n9fgplrpxdlr4s";
  };

  sourceRoot = "source/ltfs";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ 
    fuse icu libxml2 libuuid
  ];

  meta = with stdenv.lib; {
    description = "HPE's implementation of the open-source tape filesystem standard ltfs";
    homepage = "https://support.hpe.com/hpesc/public/km/product/1009214665/Product";
    license = licenses.lgpl21;
    maintainers = [ maintainers.redvers ];
    platforms = platforms.linux;
    downloadPage = "https://github.com/nix-community/hpe-ltfs";
  };
}
