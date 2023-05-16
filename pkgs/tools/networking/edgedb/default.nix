{ stdenv
, lib
<<<<<<< HEAD
=======
, runCommand
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, patchelf
, fetchFromGitHub
, rustPlatform
, makeBinaryWrapper
, pkg-config
, curl
, Security
, CoreServices
, libiconv
, xz
, perl
, substituteAll
# for passthru.tests:
, edgedb
, testers
}:

rustPlatform.buildRustPackage rec {
  pname = "edgedb";
<<<<<<< HEAD
  version = "3.4.0";
=======
  version = "2.3.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "edgedb";
    repo = "edgedb-cli";
    rev =  "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-w6YpjSmh517yat45l4gGdV6qWD4O3aCx/6LL5wea+RA=";
    fetchSubmodules = true;
=======
    sha256 = "sha256-iL8tD6cvFVWqsQAk6HBUqdz7MJ3lT2XmExGQvdQdIWs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
<<<<<<< HEAD
      "edgedb-derive-0.5.0" = "sha256-y/mN0XuJtQBtkLmbk2s7hK5joGEH5Ge6sLCD88WyL9o=";
      "edgeql-parser-0.1.0" = "sha256-Y3gXxPuR7qnTL4fu2nZIa3e20YV1fLvm2jHAng+Ke2Q=";
      "indexmap-2.0.0-pre" = "sha256-QMOmoUHE1F/sp+NeDpgRGqqacWLHWG02YgZc5vAdXZY=";
      "rexpect-0.5.0" = "sha256-vstAL/fJWWx7WbmRxNItKpzvgGF3SvJDs5isq9ym/OA=";
      "rustyline-8.0.0" = "sha256-CrICwQbHPzS4QdVIEHxt2euX+g+0pFYe84NfMp1daEc=";
=======
      "assert_cmd-1.0.1" = "sha256-0MkQG+JKrZXOn8B8q1HdyhZ1hVVb7dPbGEo/76o2YRc=";
      "edgedb-derive-0.4.0" = "sha256-pE/GchC3JDg0E4twmov86byne+rn28JpIawBbZcJHOg=";
      "edgeql-parser-0.1.0" = "sha256-e43PBHirALfrxGKi50KvE9aDAunObpXcWNBs62ssgSM=";
      "rexpect-0.3.0" = "sha256-0a//fPscEXEwv+73Ja7jRf2eRWfF6VCsck9ZZ15zgog=";
      "rustyline-8.0.0" = "sha256-FyMx2nAVaX0pc481BTlNxeR/NfNrr57FWKLS7+EjPVw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      "serde_str-1.0.0" = "sha256-CMBh5lxdQb2085y0jc/DrV6B8iiXvVO2aoZH/lFFjak=";
    };
  };

  nativeBuildInputs = [ makeBinaryWrapper pkg-config perl ];

  buildInputs = [
    curl
  ] ++ lib.optionals stdenv.isDarwin [ CoreServices Security libiconv xz ];

  checkFeatures = [ ];

  patches = [
    (substituteAll {
      src = ./0001-dynamically-patchelf-binaries.patch;
      inherit patchelf;
      dynamicLinker = stdenv.cc.bintools.dynamicLinker;
    })
  ];

  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = edgedb;
    command = "edgedb --version";
  };

  meta = with lib; {
    description = "EdgeDB cli";
    homepage = "https://www.edgedb.com/docs/cli/index";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.ranfdev ];
  };
}
