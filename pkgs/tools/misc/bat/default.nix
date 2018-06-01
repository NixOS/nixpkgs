{ stdenv, rustPlatform, fetchFromGitHub, cmake, pkgconfig, zlib }:

rustPlatform.buildRustPackage rec {
  name    = "bat-${version}";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner  = "sharkdp";
    repo   = "bat";
    rev    = "v${version}";
    sha256 = "0fiif6b8g2hdb05s028dbcpav6ax0qap2hbsr9p2bld4z7j7321m";
  };

  cargoSha256 = "0w0y3sfrpk8sn9rls90kjqrqr62pd690ripdfbvb5ipkzizp429l";

  nativeBuildInputs = [ cmake pkgconfig zlib ];

  meta = with stdenv.lib; {
    description = "A cat(1) clone with syntax highlighting and Git integration";
    homepage    = https://github.com/sharkdp/bat;
    license     = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ dywedir ];
    platforms   = platforms.linux;
  };
}
