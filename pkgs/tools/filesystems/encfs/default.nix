{ stdenv, fetchFromGitHub, autoreconfHook, boost, fuse, openssl, perl
, pkgconfig, rlog }:

let version = "1.8"; in
stdenv.mkDerivation rec {
  name = "encfs-${version}";

  src = fetchFromGitHub {
    sha256 = "1dp3558x9v5hqnjnrlnd0glrkcc23anl2mxhjirhhw8dyh1lzl5z";
    rev = "v${version}";
    repo = "encfs";
    owner = "vgough";
  };

  buildInputs = [ autoreconfHook boost fuse openssl perl pkgconfig rlog ];

  configureFlags = [
    "--with-boost-serialization=boost_wserialization"
    "--with-boost-filesystem=boost_filesystem"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://vgough.github.io/encfs;
    description = "Provides an encrypted filesystem in user-space via FUSE";
    license = with licenses; lgpl2;
    maintainers = with maintainers; [ nckx ];
  };
}
