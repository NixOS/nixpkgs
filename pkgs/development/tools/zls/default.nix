{ stdenv, lib, fetchFromGitHub, zig }:

stdenv.mkDerivation rec {
  pname = "zls";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "zigtools";
    repo = pname;
    rev = version;
    sha256 = "sha256-A4aOdmlIxBUeKyczzLxH4y1Rl9TgE1EeiKGbWY4p/00=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ zig ];

  preBuild = ''
    export HOME=$TMPDIR
  '';

  installPhase = ''
    zig build -Drelease-safe --prefix $out install
  '';

  meta = with lib; {
    description = "Zig LSP implementation + Zig Language Server";
    changelog = "https://github.com/zigtools/zls/releases/tag/${version}";
    homepage = "https://github.com/zigtools/zls";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ fortuneteller2k ];
  };
}
