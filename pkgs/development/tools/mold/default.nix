{ stdenv
, fetchFromGitHub
, lib
, autoPatchelfHook
, cmake
, tbb
, llvmPackages_latest
, xxHash
, zlib
, openssl
}:

stdenv.mkDerivation rec {
  pname = "mold";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "rui314";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2LXOPirhjAifKYPgngUJwEdGrKMYsRySr5TL2x2p8J0=";
  };

  buildInputs = [ tbb zlib openssl ];
  nativeBuildInputs = [ autoPatchelfHook cmake xxHash ];

  dontUseCmakeConfigure = true;
  EXTRA_LDFLAGS = "-fuse-ld=${llvmPackages_latest.lld}/bin/ld.lld";
  LTO = 1;
  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    description = "A high performance drop-in replacement for existing unix linkers";
    homepage = "https://github.com/rui314/mold";
    license = lib.licenses.agpl3Plus;
    maintainers = with maintainers; [ nitsky ];
    broken = stdenv.isAarch64;
  };
}
