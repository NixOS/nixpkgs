{ stdenv, fetchFromGitHub, rustPlatform, openssl, cmake, perl, pkgconfig, zlib }:

with rustPlatform;

let
  # check for updates
  zoneinfo_compiled = fetchFromGitHub {
    owner = "rust-datetime";
    repo = "zoneinfo-compiled";
    rev = "f56921ea5e9f7cf065b1480ff270a1757c1f742f";
    sha256 = "1xmw7c5f5n45lkxnyxp4llfv1bnqhc876w98165ccdbbiylfkw26";
  };
  cargoPatch = ''
    # use non-git dependencies
    patch -p1 <<EOF
   --- exa-v0.4.1-src.org/Cargo.toml       1970-01-01 01:00:01.000000000 +0100
   +++ exa-v0.4.1-src/Cargo.toml   2017-04-04 10:33:31.554377034 +0200
   @@ -42,4 +42,4 @@
    optional = true

    [dependencies.zoneinfo_compiled]
   -git = "https://github.com/rust-datetime/zoneinfo-compiled.git"
   +path = "${zoneinfo_compiled}"
EOF
  '';
in buildRustPackage rec {
  name = "exa-unstable-2017-04-02";

  depsSha256 = "0szjba03q4iwzjzb2dp39hhz554ys4z11qdhcdq1mgxqk94scjf4";

  src = fetchFromGitHub {
    owner = "ogham";
    repo = "exa";
    rev = "1a6066327d2643881996946942aba530e8a1c67c";
    sha256 = "1xrsg3zw5d3sw2bwx8g0lrs6zpk8rdrvvnknf7c9drp7rplmd8zq";
  };

  nativeBuildInputs = [ cmake pkgconfig perl ];
  buildInputs = [ openssl zlib ];

  # Some tests fail, but Travis ensures a proper build
  doCheck = false;

  cargoUpdateHook = ''
    ${cargoPatch}
  '';
  cargoDepsHook = ''
    pushd $sourceRoot
    ${cargoPatch}
    popd
  '';

  meta = with stdenv.lib; {
    description = "Replacement for 'ls' written in Rust";
    longDescription = ''
      exa is a modern replacement for ls. It uses colours for information by
      default, helping you distinguish between many types of files, such as
      whether you are the owner, or in the owning group. It also has extra
      features not present in the original ls, such as viewing the Git status
      for a directory, or recursing into directories with a tree view. exa is
      written in Rust, so it’s small, fast, and portable.
    '';
    homepage = http://bsago.me/exa;
    license = licenses.mit;
    maintainer = [ maintainers.ehegnes ];
  };
}
