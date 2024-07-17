{ lib, bundlerApp }:

bundlerApp {
  pname = "zsteg";

  gemdir = ./.;

  exes = [ "zsteg" ];

  meta = with lib; {
    description = "Detect stegano-hidden data in PNG & BMP";
    homepage = "http://zed.0xff.me/";
    license = licenses.mit;
    maintainers = with maintainers; [
      applePrincess
      h7x4
    ];
    mainProgram = "zsteg";
  };
}
