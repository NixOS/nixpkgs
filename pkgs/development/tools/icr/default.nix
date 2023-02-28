{ lib
, fetchFromGitHub
, crystal
, shards
, makeWrapper
, pkg-config
, which
, openssl
, readline
, libyaml
, zlib
}:

crystal.buildCrystalPackage rec {
  pname = "icr";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "crystal-community";
    repo = "icr";
    rev = "v${version}";
    hash = "sha256-29B/i8oEjwNOYjnc78QcYTl6fC/M9VfAVCCBjLBKp0Q=";
  };

  shardsFile = ./shards.nix;

  buildInputs = [ libyaml openssl readline zlib ];

  nativeBuildInputs = [ makeWrapper pkg-config which ];

  # tests are failing due to our sandbox
  doCheck = false;

  postFixup = ''
    wrapProgram $out/bin/icr \
      --prefix PATH : ${lib.makeBinPath [ crystal shards which ]}
  '';

  meta = with lib; {
    description = "Interactive console for the Crystal programming language";
    homepage = "https://github.com/crystal-community/icr";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
