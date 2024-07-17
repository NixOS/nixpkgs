{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "goofys";
  version = "unstable-2022-04-21";

  src = fetchFromGitHub {
    owner = "kahing";
    repo = "goofys";
    # Same as v0.24.0 but migrated to Go modules
    rev = "829d8e5ce20faa3f9f6f054077a14325e00e9249";
    sha256 = "sha256-6yVMNSwwPZlADXuPBDRlgoz4Stuz2pgv6r6+y2/C8XY=";
  };

  vendorHash = "sha256-shFld293pdmVcnu3p0NoBmPGLJddZd4O/gJ8klgdlQ8=";

  subPackages = [ "." ];

  # Tests are using networking
  postPatch = ''
    rm internal/*_test.go
  '';

  meta = {
    homepage = "https://github.com/kahing/goofys";
    description = "High-performance, POSIX-ish Amazon S3 file system written in Go";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.adisbladis ];
    broken = stdenv.isDarwin; # needs to update gopsutil to at least v3.21.3 to include https://github.com/shirou/gopsutil/pull/1042
    mainProgram = "goofys";
  };

}
