{ stdenv, autoreconfHook, fetchFromGitHub, zlib, libibmad, openssl }:

stdenv.mkDerivation rec {
  pname = "mstflint";
  version = "4.14.0-1";

  src = fetchFromGitHub {
    owner = "Mellanox";
    repo = pname;
    rev = "v${version}";
    sha256 = "0xrwx623vl17cqzpacil74m2fi4xrshgvvzxiplz1wq47gq7wp1i";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ zlib libibmad openssl ];

  hardeningDisable = [ "format" ];

  dontDisableStatic = true;  # the build fails without this. should probably be reported upstream

  meta = with stdenv.lib; {
    homepage = "https://github.com/Mellanox/mstflint";
    license = with licenses; [ gpl2 bsd2 ];
    platforms = platforms.linux;
  };
}
