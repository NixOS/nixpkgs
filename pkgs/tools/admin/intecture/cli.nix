{ lib, fetchFromGitHub, rustPlatform
, openssl, zeromq, czmq, pkg-config, cmake, zlib }:

with rustPlatform;

buildRustPackage rec {
  pname = "intecture-cli";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "intecture";
    repo = "cli";
    rev = version;
    sha256 = "16a5fkpyqkf8w20k3ircc1d0qmif7nygkzxj6mzk9609dlb0dmxq";
  };

  cargoSha256 = "1hfnmqyd1y68ps9aba1ai762i9cw8cynxwwdq8kpdx67xxyf1p51";

  buildInputs = [ openssl zeromq czmq zlib ];

  nativeBuildInputs = [ pkg-config cmake ];

  # Needed for tests
  USER = "$(whoami)";

  meta = with lib; {
    description = "A developer friendly, language agnostic configuration management tool for server systems";
    homepage = "https://intecture.io";
    license = licenses.mpl20;
    maintainers = [ maintainers.rushmorem ];
  };
}
