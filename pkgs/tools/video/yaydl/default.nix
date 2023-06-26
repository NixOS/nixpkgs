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
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "dertuxmalwieder";
    repo = pname;
    rev = "release-${version}";
    sha256 = "sha256-JwyWWqbUNZyH6gymeScb9tMZoPvn/Igz9iW2pp0XvEI=";
  };

  cargoSha256 = "sha256-jmqO0UvU6s+E5r6VFFjOvSe8oiLiTG5rPNHzoHVftWo=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [ openssl ]
    ++ lib.optional stdenv.isDarwin Security;

  postInstall = ''
    wrapProgram $out/bin/yaydl \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg ]}
  '';

  meta = with lib; {
    homepage = "https://code.rosaelefanten.org/yaydl";
    description = "Yet another youtube down loader";
    license = licenses.cddl;
    maintainers = with maintainers; [ earthengine ];
  };
}
