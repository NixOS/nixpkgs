{ stdenv, fetchFromGitHub, rustPlatform, nix, boost, graphviz, darwin }:
rustPlatform.buildRustPackage rec {
  name = "nix-du-${version}";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "symphorien";
    repo = "nix-du";
    rev = "v${version}";
    sha256 = "1x6qpivxbn94034jfdxb97xi97fhcdv2z7llq2ccfc80mgd0gz8l";
  };
  cargoSha256 = "0sva4lnhccm6ly7pa6m99s3fqkmh1dzv7r2727nsg2f55prd4kxc";

  doCheck = true;
  checkInputs = [ graphviz ];

  buildInputs = [
    boost
    nix
  ] ++ stdenv.lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

  meta = with stdenv.lib; {
    description = "A tool to determine which gc-roots take space in your nix store";
    homepage = https://github.com/symphorien/nix-du;
    license = licenses.lgpl3;
    maintainers = [ maintainers.symphorien ];
    platforms = platforms.unix;
  };
}
