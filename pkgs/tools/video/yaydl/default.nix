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
  version = "0.15.5";

  src = fetchFromGitHub {
    owner = "dertuxmalwieder";
    repo = pname;
    rev = "release-${version}";
    sha256 = "sha256-/GoRMdbTaRDZJaVXdsN+YKpWCgecOhqhRf3iaL0rmE8=";
  };

  cargoHash = "sha256-f81z4ssKyGheuI2WWweFBW8AoafsVgPkX1lYCHDSaaM=";

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
