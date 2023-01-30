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
  version = "unstable-2021-03-14";

  src = fetchFromGitHub {
    owner = "crystal-community";
    repo = "icr";
    rev = "b6b335f40aff4c2c07d21250949935e8259f7d1b";
    sha256 = "sha256-Qoy37lCdHFnMAuuqyB9uT15/RLllksFyApYAGy+RmDs=";
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
