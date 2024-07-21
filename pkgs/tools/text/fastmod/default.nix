{ lib, stdenv
, fetchFromGitHub
, rustPlatform
, libiconv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "fastmod";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-A/3vzfwaStoQ9gdNM8yjmL2J/pQjj6yb68WThiTF+1E=";
  };

  cargoHash = "sha256-sFrABp4oYhel+GONFsTbunq+4We2DicvF9A3FT/ZArc=";

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security ];

  meta = with lib; {
    description = "Utility that makes sweeping changes to large, shared code bases";
    mainProgram = "fastmod";
    homepage = "https://github.com/facebookincubator/fastmod";
    license = licenses.asl20;
    maintainers = with maintainers; [ jduan ];
  };
}
