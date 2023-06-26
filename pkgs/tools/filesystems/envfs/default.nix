{ rustPlatform, lib, fetchFromGitHub, nixosTests }:
rustPlatform.buildRustPackage rec {
  pname = "envfs";
  version = "1.0.1";
  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "envfs";
    rev = version;
    hash = "sha256-ttW1NUCtwnjAoiu7QgLGrlAB2PyY4oXm91LpWhbz8qk=";
  };
  cargoHash = "sha256-BgXKwKD6w/GraBQEq61D7S7m2Q9TnkXNFJEIgDYo9L4=";

  passthru.tests = {
    envfs = nixosTests.envfs;
  };

  postInstall = ''
    ln -s envfs $out/bin/mount.envfs
    ln -s envfs $out/bin/mount.fuse.envfs
  '';
  meta = with lib; {
    description = "Fuse filesystem that returns symlinks to executables based on the PATH of the requesting process.";
    homepage = "https://github.com/Mic92/envfs";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
    platforms = platforms.linux;
  };
}
