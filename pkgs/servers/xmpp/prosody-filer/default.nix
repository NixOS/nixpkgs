{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "prosody-filer";
  version = "unstable-2021-05-24";

  src = fetchFromGitHub {
    owner = "ThomasLeister";
    repo = "prosody-filer";
    rev = "c65edd199b47dc505366c85b3702230fda797cd6";
    hash = "sha256-HrCJjsa3cYK1g7ylkDiCikgxJzbuGg1/5Zz4R12520A=";
  };

  vendorHash = "sha256-bbkCxS0UU8PIg/Xjo2X1Mia3WHjtBxYGmwj1c/ScVxc=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/ThomasLeister/prosody-filer";
    maintainers = with maintainers; [ abbradar ];
    license = licenses.mit;
    platforms = platforms.linux;
    description = "A simple file server for handling XMPP http_upload requests";
    mainProgram = "prosody-filer";
  };
}
