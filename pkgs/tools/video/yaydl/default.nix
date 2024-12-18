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
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "dertuxmalwieder";
    repo = pname;
    rev = "release-${version}";
    sha256 = "sha256-mMV7fnl3tEM22LCTLXoXG9RQhPSQ7DXanSURdoa0+EI=";
  };

  cargoHash = "sha256-HsRg8SO9c9Fomeb5B+kOW3VDNIG4W+dagEwAoWqONyA=";

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
