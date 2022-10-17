{ stdenv, lib, fetchFromGitHub, zig }:

stdenv.mkDerivation rec {
  pname = "zls";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "zigtools";
    repo = pname;
    rev = version;
    sha256 = "sha256-MVo21qNCZop/HXBqrPcosGbRY+W69KNCc1DfnH47GsI=";
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
    platforms = platforms.unix;
  };
}
