{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, rust
, libiconv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-deb";
  version = "1.30.0";

  src = fetchFromGitHub {
    owner = "mmstick";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-rAmG6Aj0D9dHVueh1BN1Chhit+XFhqGib1WTvMDy0LI=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security ];

  cargoSha256 = "sha256-MEpyEdjLWNZvqE7gJLvQ169tgmJRzec4vqQI9fF3xr8=";

  preCheck = ''
    substituteInPlace tests/command.rs \
      --replace 'target/debug' "target/${rust.toRustTarget stdenv.buildPlatform}/release"

    # This is an FHS specific assert depending on glibc location
    substituteInPlace src/dependencies.rs \
      --replace 'assert!(deps.iter().any(|d| d.starts_with("libc")));' '// no libc assert here'
  '';

  meta = with lib; {
    description = "Generate Debian packages from information in Cargo.toml";
    homepage = "https://github.com/mmstick/cargo-deb";
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
