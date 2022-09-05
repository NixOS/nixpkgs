{ stdenv
, lib
, buildGoModule
, fetchFromGitHub
, libpcap
}:

buildGoModule rec {
  pname = "sx-go";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "v-byte-cpu";
    repo = "sx";
    rev = "v${version}";
    sha256 = "sha256-HTIzA1QOVn3V/hGUu7wLIYUNYmcJ/FXi2yr6BGRizZA=";
  };

  vendorSha256 = "sha256-TWRMNt6x8zuvhP1nz4R6IVCX+9HityvVpzxRhDiMyO4=";

  buildInputs = [
    libpcap
  ];

  postFixup = ''
    # Rename binary to avoid conflict with sx
    mv $out/bin/sx $out/bin/${pname}
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Command-line network scanner";
    homepage = "https://github.com/v-byte-cpu/sx";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
