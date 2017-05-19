{ stdenv, lib, fetchFromGitHub, autoreconfHook, makeWrapper, pkgconfig
, zlib, lzma, bzip2, mtools, dosfstools, zip, unzip, libconfuse, libsodium
, libarchive, darwin, coreutils }:

stdenv.mkDerivation rec {
  name = "fwup-${version}";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "fhunleth";
    repo = "fwup";
    rev = "v${version}";
    sha256 = "0ddyiprq4qnqpdhh48bivl8c5yrh21p4r99qs0d1rjiwx5h9p21l";
  };

  doCheck = true;
  patches = lib.optional stdenv.isDarwin [ ./fix-testrunner-darwin.patch ];

  nativeBuildInputs = [ pkgconfig autoreconfHook makeWrapper ];
  buildInputs = [ zlib lzma bzip2 libconfuse libsodium libarchive ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.DiskArbitration
    ];
  propagatedBuildInputs = [ zip unzip mtools dosfstools coreutils ];

  # segfaults on darwin without
  NIX_LDFLAGS = lib.optional stdenv.isDarwin "-F/System/Library/Frameworks";

  meta = with stdenv.lib; {
    description = "Configurable embedded Linux firmware update creator and runner";
    homepage = https://github.com/fhunleth/fwup;
    license = licenses.asl20;
    maintainers = [ maintainers.georgewhewell ];
    platforms = platforms.all;
  };
}
