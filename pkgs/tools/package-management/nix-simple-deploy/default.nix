{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "nix-simple-deploy";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "misuzu";
    repo = pname;
    rev = version;
    sha256 = "12g0sbgs2dfnk0agp1kagfi1yhk26ga98zygxxrjhjxrqb2n5w80";
  };

  cargoSha256 = "0svnz9r0lrmz333qpbpdddjd46vh9i74qchws8aifa2qwnqy0kmn";

  meta = with stdenv.lib; {
    description = "Deploy software or an entire NixOS system configuration to another NixOS system";
    homepage = "https://github.com/misuzu/nix-simple-deploy";
    license = with licenses; [ asl20 /* OR */ mit ];
    platforms = platforms.all;
    maintainers = with maintainers; [ misuzu ];
  };
}
