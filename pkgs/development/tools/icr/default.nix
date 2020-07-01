{ stdenv, lib, fetchFromGitHub, crystal, shards, makeWrapper, pkgconfig, which
, openssl, readline, libyaml, zlib }:

crystal.buildCrystalPackage rec {
  pname = "icr";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "crystal-community";
    repo = pname;
    rev = "v${version}";
    sha256 = "1bz2bhs6csyg2rhrlknlvaiilq3vq8plxjh1hdxmbrfi3n6c7k5a";
  };

  shardsFile = ./shards.nix;

  buildInputs = [ libyaml openssl readline zlib ];

  nativeBuildInputs = [ makeWrapper pkgconfig which ];

  # tests are failing due to our sandbox
  doCheck = false;

  postFixup = ''
    wrapProgram $out/bin/icr \
      --prefix PATH : ${lib.makeBinPath [ crystal shards makeWrapper which ]}
  '';

  meta = with stdenv.lib; {
    description = "Interactive console for the Crystal programming language";
    homepage = "https://github.com/crystal-community/icr";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
