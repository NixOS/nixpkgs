# To update:
# - fetch mavenix from the URL given below
# - nix-env path/to/mavenix/checkout
# - mvnix-update ./default.nix
# Check mavenix.lock and do a test build before commiting; in particular,
# mvnix-update has a bug where it may delete the sha256s for extra JARs that
# are packaged with airsonic (currently dwr and natpmp). If it does so, revert
# those diff hunks before committing.
let
  mavenix-src = fetchTarball {
    url = "https://github.com/icetan/mavenix/tarball/v2.3.3";
    sha256 = "1l653ac3ka4apm7s4qrbm4kx7ij7n2zk3b67p9l0nki8vxxi8jv7";
  };
in {
  # The slightly weird construction here is necessary for mvnix-update to work
  # properly. It's not evaluated for normal builds.
  pkgs ? (import mavenix-src {}).pkgs,
  mavenix ? import ./mavenix.nix { inherit pkgs; },
  doCheck ? false,
}: mavenix.buildMaven rec {
  inherit doCheck;
  infoFile = ./mavenix.lock;
  src = pkgs.fetchFromGitHub {
    owner = "airsonic";
    repo = "airsonic";
    rev = "v10.6.2";
    sha256 = "1f3mql0d5h1ql95fsnkya3qih0rfcmxwas0r6yld7nv0iximzpsy";
  };
  remotes = { local1 = "file://${src}/repo"; };

  # dependency-check relies on downloading undeclared dependencies at check
  # time and thus isn't hermetic, nor is it necessary for the build.
  MAVEN_OPTS = "-Ddependency-check.skip=true";

  # Backwards compatibility with previous Airsonic package.
  postInstall = ''
    cd "$out"
    ln -s share/java/ webapps
  '';

  meta = with pkgs.stdenv.lib; {
    description = "Personal media streamer";
    homepage = "https://airsonic.github.io";
    license = pkgs.stdenv.lib.licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ disassembler ToxicFrog ];
  };
}
