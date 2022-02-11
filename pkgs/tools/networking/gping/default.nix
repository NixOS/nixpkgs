{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, libiconv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "gping";
  version = "1.2.7";

  src = fetchFromGitHub {
    owner = "orf";
    repo = "gping";
    rev = "gping-v${version}";
    sha256 = "sha256-7o7Tj0jWFIOLmpHXWT6zcyowm7vnqMDTf0S4zHkWQ2Q=";
  };

  cargoSha256 = "sha256-t+68Rea74RE43TXTSyhZCLXCdBfh7K92Z/amO+wBUuI=";

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security ];

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/gping --version | grep "${version}"
  '';

  meta = with lib; {
    description = "Ping, but with a graph";
    homepage = "https://github.com/orf/gping";
    license = licenses.mit;
    maintainers = with maintainers; [ andrew-d ];
  };
}
