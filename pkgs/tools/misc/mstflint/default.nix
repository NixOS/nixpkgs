{ lib, stdenv, autoreconfHook, fetchFromGitHub, zlib, libibmad, openssl }:

stdenv.mkDerivation rec {
  pname = "mstflint";
  version = "4.14.0-3";

  src = fetchFromGitHub {
    owner = "Mellanox";
    repo = pname;
    rev = "v${version}";
    sha256 = "0zy9npyzf7dkxlfl9mx6997aa61mk23ixpjb01ckb1wvav5k6z82";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ zlib libibmad openssl ];

  hardeningDisable = [ "format" ];

  dontDisableStatic = true;  # the build fails without this. should probably be reported upstream

  meta = with lib; {
    description = "Open source version of Mellanox Firmware Tools (MFT)";
    homepage = "https://github.com/Mellanox/mstflint";
    license = with licenses; [ gpl2 bsd2 ];
    platforms = platforms.linux;
  };
}
