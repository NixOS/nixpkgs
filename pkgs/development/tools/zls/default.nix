{ stdenv, lib, fetchFromGitHub, zig }:

stdenv.mkDerivation rec {
  pname = "zls";
  version = "unstable-2021-06-06";

  src = fetchFromGitHub {
    owner = "zigtools";
    repo = pname;
    rev = "39d87188647bd8c8eed304ee18f2dd1df6942f60";
    sha256 = "sha256-22N508sVkP1OLySAijhtTPzk2fGf+FVnX9LTYRbRpB4=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ zig ];

  preBuild = ''
    export HOME=$TMPDIR
  '';

  installPhase = ''
    zig build -Drelease-safe -Dcpu=baseline --prefix $out install
  '';

  meta = with lib; {
    description = "Zig LSP implementation + Zig Language Server";
    changelog = "https://github.com/zigtools/zls/releases/tag/${version}";
    homepage = "https://github.com/zigtools/zls";
    license = licenses.mit;
    maintainers = with maintainers; [ fortuneteller2k ];
  };
}
