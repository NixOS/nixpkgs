{ stdenv
, fetchFromGitHub
, lib
, autoPatchelfHook
, cmake
, llvmPackages_latest
, xxHash
, zlib
, openssl
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "mold";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "rui314";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-L/io0kMYkFVSmOiH6sM/CoibE1rPRwDM0fFddw6kM+4=";
  };

  buildInputs = [ zlib openssl ];
  nativeBuildInputs = [ autoPatchelfHook cmake xxHash ];

  enableParallelBuilding = true;
  dontUseCmakeConfigure = true;
  EXTRA_LDFLAGS = "-fuse-ld=${llvmPackages_latest.lld}/bin/ld.lld";
  LTO = 1;
  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with lib; {
    description = "A high performance drop-in replacement for existing unix linkers";
    homepage = "https://github.com/rui314/mold";
    license = lib.licenses.agpl3Plus;
    maintainers = with maintainers; [ nitsky ];
    broken = stdenv.isAarch64;
  };
}
