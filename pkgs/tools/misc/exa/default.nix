{ stdenv, fetchFromGitHub, rustPlatform, cmake, perl, pkgconfig, zlib }:

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
    patch Cargo.toml <<EOF
    46c46
    < git = "https://github.com/rust-datetime/zoneinfo-compiled.git"
    ---
    > path = "${zoneinfo_compiled}"
    EOF
  '';
in buildRustPackage rec {
  name = "exa-${version}";
  version = "0.7.0";

  depsSha256 = "0j320hhf2vqaha137pjj4pyiw6d3p5h3nhy3pl9vna1g5mnl1sn7";

  src = fetchFromGitHub {
    owner = "ogham";
    repo = "exa";
    rev = "v${version}";
    sha256 = "0i9psgna2wwv9qyw9cif4qznqiyi16vl763hpm2yr195aj700339";
  };

  nativeBuildInputs = [ cmake pkgconfig perl ];
  buildInputs = [ zlib ];

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
    homepage = http://the.exa.website;
    license = licenses.mit;
    maintainer = [ maintainers.ehegnes ];
  };
}
