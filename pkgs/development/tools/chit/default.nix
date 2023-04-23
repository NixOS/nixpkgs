{ lib, stdenv, fetchFromGitHub, rustPlatform, pkg-config, openssl
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "chit";
  version = "0.1.15";

  src = fetchFromGitHub {
    owner = "peterheesterman";
    repo = pname;
    rev = version;
    sha256 = "0iixczy3cad44j2d7zzj8f3lnmp4jwnb0snmwfgiq3vj9wrn28pz";
  };

  cargoSha256 = "1y6k24p4m67v5773rzid2r0jwxp9piggrp0462z446hbcam2r4gd";

  nativeBuildInputs = lib.optionals stdenv.isLinux [ pkg-config ];
  buildInputs = []
  ++ lib.optionals stdenv.isLinux [ openssl ]
  ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ CoreFoundation CoreServices Security ])
  ;

  meta = with lib; {
    description = "Crate help in terminal: A tool for looking up details about rust crates without going to crates.io";
    longDescription = ''
      Chit helps answer these questions:

      * Who wrote this crate? What else did they write?
      * What alternatives are there?
      * How old is this crate?
      * What versions are there? When did they come out?
      * What are the downloads over time?
      * Should i use this crate?
      * How mature is it?
    '';
    homepage = "https://github.com/peterheesterman/chit";
    license = licenses.mit;
    maintainers = [ maintainers.lilyball ];
  };
}
