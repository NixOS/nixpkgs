{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, makeWrapper
, openssl
, ffmpeg
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "yaydl";
  version = "0.17.2";

  src = fetchFromGitHub {
    owner = "dertuxmalwieder";
    repo = pname;
    rev = "release-${version}";
    sha256 = "sha256-r+UkwEtuGL6los9ohv86KA/3qsaEkpnI4yV/UnYelgk=";
  };

  cargoHash = "sha256-nEZBrtfUFybXIp7PBbR6X32GfIkjNylqpxaPOqNy+ww=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [ openssl ]
    ++ lib.optional stdenv.hostPlatform.isDarwin Security;

  postInstall = ''
    wrapProgram $out/bin/yaydl \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg ]}
  '';

  meta = with lib; {
    homepage = "https://code.rosaelefanten.org/yaydl";
    description = "Yet another youtube down loader";
    license = licenses.cddl;
    maintainers = [ ];
    mainProgram = "yaydl";
  };
}
