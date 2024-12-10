{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  name = "sigtop";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "tbvdm";
    repo = "sigtop";
    rev = "v${version}";
    sha256 = "sha256-EQWi+3n3Srsa3MHQym7IIFxxyATnb/79bgy8eqOB46k=";
  };

  vendorHash = "sha256-IFF7zTrHHoEmPoHGOkTHrb7o+9D5PC8Q+MWHSR2EXog=";

  makeFlags = [
    "PREFIX=\${out}"
  ];

  meta = with lib; {
    description = "Utility to export messages, attachments and other data from Signal Desktop";
    mainProgram = "sigtop";
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = with maintainers; [ fricklerhandwerk ];
  };
}
