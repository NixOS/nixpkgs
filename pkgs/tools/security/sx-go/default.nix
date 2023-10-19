{ lib
, buildGoModule
, fetchFromGitHub
, fetchpatch
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

  vendorHash = "sha256-TWRMNt6x8zuvhP1nz4R6IVCX+9HityvVpzxRhDiMyO4=";

  patches = [
    # Fix darwin builds: https://github.com/v-byte-cpu/sx/pull/120
    (fetchpatch {
      name = "non-linux-method-signature.patch";
      url = "https://github.com/v-byte-cpu/sx/commit/56457bfaa49eb6fbb7a33d7092d9c636b9c85895.patch";
      hash = "sha256-0lCu3tZ0fEiC7qWfk1APLVwwrK9eovbVa/yG7OuXEWQ=";
    })
  ];

  buildInputs = [
    libpcap
  ];

  postFixup = ''
    # Rename binary to avoid conflict with sx
    mv $out/bin/sx $out/bin/${pname}
  '';

  meta = with lib; {
    description = "Command-line network scanner";
    homepage = "https://github.com/v-byte-cpu/sx";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
