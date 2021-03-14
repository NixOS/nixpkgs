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
  version = "unstable-2020-10-06";

  src = fetchFromGitHub {
    owner = "crystal-community";
    repo = "icr";
    rev = "8c57cd7c1fdf8088cb05c1587bd6c40d244a8a80";
    sha256 = "sha256-b0w6oG2npNgdi2ZowMlJy0iUxQWqb9+DiruQl7Ztb0E=";
  };

  shardsFile = ./shards.nix;

  buildInputs = [ libyaml openssl readline zlib ];

  nativeBuildInputs = [ makeWrapper pkg-config which ];

  # tests are failing due to our sandbox
  doCheck = false;

  postFixup = ''
    wrapProgram $out/bin/icr \
      --prefix PATH : ${lib.makeBinPath [ crystal shards makeWrapper which ]}
  '';

  meta = with lib; {
    description = "Interactive console for the Crystal programming language";
    homepage = "https://github.com/crystal-community/icr";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
