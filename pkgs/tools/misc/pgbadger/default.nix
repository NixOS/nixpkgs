{ lib, perlPackages, buildPerlPackage, fetchFromGitHub, which, bzip2 }:
buildPerlPackage rec {
    pname = "pgbadger";
    version = "11.5";
    src = fetchFromGitHub {
        owner = "darold";
        repo = "pgbadger";
        rev = "v${version}";
        sha256 = "sha256-9c5GAVDNACVzqpXjR8HwI3YU4Wz6ATB7Qxgq4YlEzQk=";
    };

    postPatch = ''
      patchShebangs ./pgbadger
    '';

    outputs = [ "out" ];

    DESTDIR = placeholder "out";

    buildInputs = [
      which bzip2
    ];

    propagatedBuildInputs = with perlPackages; [
        JSONXS TextCSV
    ];

    meta = {
        homepage = "https://github.com/darold/pgbadger";
        description = "A fast PostgreSQL Log Analyzer";
        license = lib.licenses.postgresql;
        maintainers = lib.teams.determinatesystems.members;
    };
}
