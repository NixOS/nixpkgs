{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "plistwatch";
  version = "unstable-2020-12-22";

  src = fetchFromGitHub {
    owner = "catilac";
    repo = "plistwatch";
    rev = "c3a9afd8d3e5ffa8dcc379770bc4216bae88a671";
    sha256 = "0a5rfmpy6h06p02z9gdilh7vr3h9cc6n6zzygpjk6zvnqs3mm3vx";
  };

  vendorSha256 = "sha256-Layg1axFN86OFgxEyNFtIlm6Jtx317jZb/KH6IjJ8e4=";

  #add missing dependencies and hashes
  patches = [ ./go-modules.patch ];

  doCheck = false;

  meta = with lib; {
    description = "Monitors and prints changes to MacOS plists in real time";
    homepage = "https://github.com/catilac/plistwatch";
    maintainers = with maintainers; [ gdinh ];
    license = licenses.mit;
    platforms = platforms.darwin;
  };
}
