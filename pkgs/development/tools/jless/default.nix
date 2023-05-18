{ lib, fetchFromGitHub, rustPlatform, stdenv, python3, AppKit, libxcb }:

rustPlatform.buildRustPackage rec {
  pname = "jless";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "PaulJuliusMartinez";
    repo = "jless";
    rev = "v${version}";
    sha256 = "sha256-NB/s29M46mVhTsJWFYnBgJjSjUVbfdmuz69VdpVuR7c=";
  };

  cargoSha256 = "sha256-cPj9cTRhWK/YU8Cae63p4Vm5ohB1IfGL5fu7yyFGSXA=";

  nativeBuildInputs = lib.optionals stdenv.isLinux [ python3 ];

  buildInputs = [ ]
    ++ lib.optionals stdenv.isDarwin [ AppKit ]
    ++ lib.optionals stdenv.isLinux [ libxcb ];

  meta = with lib; {
    description = "A command-line pager for JSON data";
    homepage = "https://jless.io";
    license = licenses.mit;
    maintainers = with maintainers; [ jfchevrette ];
  };
}
