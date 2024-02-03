{ lib
, fetchFromGitHub
, libpcap
, libseccomp
, pkg-config
, rustPlatform
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "sniffglue";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-MOw0WBdpo6dYXsjbUrqoIJl/sjQ4wSAcm4dPxDgTYgY=";
  };

  cargoHash = "sha256-vnfviiXJ4L/j5M3N+LegOIvLuD6vYJB1QeBgZJVfDnI=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libpcap
  ] ++ lib.optionals stdenv.isLinux [
    libseccomp
  ];

  meta = with lib; {
    description = "Secure multithreaded packet sniffer";
    homepage = "https://github.com/kpcyrd/sniffglue";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ xrelkd ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
