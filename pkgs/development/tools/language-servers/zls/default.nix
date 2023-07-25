{ stdenv, lib, fetchFromGitHub, zig }:

stdenv.mkDerivation rec {
  pname = "zls";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "zigtools";
    repo = pname;
    rev = version;
    sha256 = "sha256-M0GG4KIMcHN+bEprUv6ISZkWNvWN12S9vqSKP+DRU9M=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ zig ];

  dontConfigure = true;

  preBuild = ''
    export HOME=$TMPDIR
  '';

  installPhase = ''
    runHook preInstall
    zig build -Drelease-safe -Dcpu=baseline --prefix $out install
    runHook postInstall
  '';

  meta = with lib; {
    description = "Zig LSP implementation + Zig Language Server";
    changelog = "https://github.com/zigtools/zls/releases/tag/${version}";
    homepage = "https://github.com/zigtools/zls";
    license = licenses.mit;
    maintainers = with maintainers; [ fortuneteller2k ];
    platforms = platforms.unix;
  };
}
