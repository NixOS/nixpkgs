{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, rust
, libiconv
, Security
, dpkg
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-deb";
  version = "1.41.0";

  src = fetchFromGitHub {
    owner = "kornelski";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2N7KFkR0HZHvEO6ud88MyvPi4epyq0ISMXz+RPWNDoQ=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security ];
  nativeBuildInputs = [ dpkg ];

  cargoSha256 = "sha256-PJLKEcbWlGqfi7RxWO4mwxByMD/qeK0MWy+r61WSKzo=";

  preCheck = ''
    substituteInPlace tests/command.rs \
      --replace 'target/debug' "target/${rust.toRustTarget stdenv.buildPlatform}/release"

    # This is an FHS specific assert depending on glibc location
    substituteInPlace src/dependencies.rs \
      --replace 'assert!(deps.iter().any(|d| d.starts_with("libc")));' '// no libc assert here'
  '';

  meta = with lib; {
    description = "Generate Debian packages from information in Cargo.toml";
    homepage = "https://github.com/kornelski/cargo-deb";
    license = licenses.mit;
    # test failures:
    #   control::tests::generate_scripts_generates_maintainer_scripts_for_unit
    #   dh_installsystemd::tests::find_units_in_empty_dir_finds_nothing
    #   dh_lib::tests::apply_with_no_matching_files
    #   dh_lib::tests::debhelper_script_subst_with_generated_file_only
    #   dh_lib::tests::debhelper_script_subst_with_no_matching_files
    #   dh_lib::tests::pkgfile_finds_most_specific_match_without_pkg_file
    #   dh_lib::tests::pkgfile_finds_most_specific_match_without_unit_file
    broken = (stdenv.isDarwin && stdenv.isx86_64);
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
