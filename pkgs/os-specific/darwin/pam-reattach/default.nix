{ lib, stdenv, fetchFromGitHub, cmake, openpam, darwin }:

let
  sdk =
    if stdenv.isAarch64
    then null
    else darwin.apple_sdk.sdk;
in

stdenv.mkDerivation rec {
  pname = "pam_reattach";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "fabianishere";
    repo = pname;
    rev = "v${version}";
    sha256 = "1k77kxqszdwgrb50w7algj22pb4fy5b9649cjb08zq9fqrzxcbz7";
  };

  cmakeFlags = [
    "-DCMAKE_OSX_ARCHITECTURES=${
      if stdenv.hostPlatform.system == "x86_64-darwin" then
        "x86_64"
      else
        "arm64"
    }"
    "-DENABLE_CLI=ON"
  ]
  ++ lib.optional (sdk != null)
    "-DCMAKE_LIBRARY_PATH=${sdk}/usr/lib";

  buildInputs = [ openpam ]
    ++ lib.optional (sdk != null) sdk;

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://github.com/fabianishere/pam_reattach";
    description = "Reattach to the user's GUI session on macOS during authentication (for Touch ID support in tmux)";
    license = licenses.mit;
    maintainers = with maintainers; [ lockejan ];
    platforms = platforms.darwin;
  };
}
