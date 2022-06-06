{ stdenv, lib, fetchFromGitHub, openssl, pkg-config }:

stdenv.mkDerivation {
  name = "sigtop";
  version = "unstable-2022-05-27";

  src = fetchFromGitHub {
    owner = "tbvdm";
    repo = "sigtop";
    # `portable` branch
    rev = "945c5844d25e2b130809334cbc8f3fa1cd85aaf9";
    sha256 = "sha256-6Ifs8fsNpE3AstNt3Elyy908sQ4JzE1H8DbUeWhGnLE=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  makeFlags = [
    "PREFIX=\${out}"
  ];

  meta = with lib; {
    description = "Utility to export messages, attachments and other data from Signal Desktop";
    license = licenses.isc;
    maintainers = with maintainers; [ fricklerhandwerk ];
  };
}
