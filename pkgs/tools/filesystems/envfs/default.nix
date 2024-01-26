{ rustPlatform, lib, fetchFromGitHub, nixosTests }:
rustPlatform.buildRustPackage rec {
  pname = "envfs";
  version = "1.0.3";
  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "envfs";
    rev = version;
    hash = "sha256-WbMqh/MzEMfZmKl/DNBGnzG3l8unFmAYbG6feSiMz+Y=";
  };
  cargoHash = "sha256-RoreNBZvTsVY87nbVibJBy4gsafFwAMctVncAhhiaP8=";

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
