{ lib
, rustPlatform
, fetchFromGitHub

, pkg-config
, libunwind
}:

rustPlatform.buildRustPackage rec {
  pname = "hermit";
  version = "unstable-2022.12.22";

  src = fetchFromGitHub {
    owner = "facebookexperimental";
    repo = "hermit";
    rev = "77fa5e36f48afd77a4d11737b3e67888a8561a92";
    hash = "sha256-qmL/f5DOReVBwL0lQK7zfgWJwreAY2HDCnzh0BUATpk=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "fbinit-0.1.2" = "sha256-u/sfx2MphmyvCgpmKufCVyEyTJrIywoxBlH4QPx1PSE=";
      "reverie-0.1.0" = "sha256-BP89MQqLhNJdxy/8bLup1CSoEqrWsrsvS5JF0azG0X8=";
    };
  };

  RUSTC_BOOTSTRAP = 1; # requires nightly

  postPatch = "cp ${./Cargo.lock} Cargo.lock";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libunwind ];

  doCheck = false;

  meta = with lib; {
    description = "Record and deterministically replay Linux programs";
    homepage = "https://github.com/facebookexperimental/hermit";
    license = with licenses; [ bsd3 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
