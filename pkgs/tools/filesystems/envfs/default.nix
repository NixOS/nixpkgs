{
  rustPlatform,
  lib,
  fetchFromGitHub,
  nixosTests,
}:
rustPlatform.buildRustPackage rec {
  pname = "envfs";
  version = "1.0.6";
  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "envfs";
    rev = version;
    hash = "sha256-kOfnKguvJQHW/AfQOetxVefjoEj7ec5ew6fumhOwP08=";
  };
  cargoHash = "sha256-isx4jBsA3HX6124R3qtwTqH5fLTAP7xdQD5bTzCAybo=";

  passthru.tests = {
    envfs = nixosTests.envfs;
  };

  postInstall = ''
    ln -s envfs $out/bin/mount.envfs
    ln -s envfs $out/bin/mount.fuse.envfs
  '';
  meta = with lib; {
    description = "Fuse filesystem that returns symlinks to executables based on the PATH of the requesting process";
    homepage = "https://github.com/Mic92/envfs";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
    platforms = platforms.linux;
  };
}
