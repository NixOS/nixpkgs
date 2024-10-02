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
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "dertuxmalwieder";
    repo = pname;
    rev = "release-${version}";
    sha256 = "sha256-BH+SRr+RYfKsXrzpqggQDJSs+aWJRSi/5tDX5mjpDkk=";
  };

  cargoHash = "sha256-q4gwa4KoWiQWKKI3sp00koiH9Ndj23a8F07e72xSF1M=";

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
