{ stdenv, fetchFromGitHub, autoreconfHook, boost, fuse, openssl, perl
, pkgconfig, rlog }:

let version = "1.8-rc1"; in
stdenv.mkDerivation rec {
  name = "encfs-${version}";

  src = fetchFromGitHub {
    sha256 = "17a09pg7752nlbgm2nmrwhm90kv2z3dj20xs79qvvr6x7rdgzck8";
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
