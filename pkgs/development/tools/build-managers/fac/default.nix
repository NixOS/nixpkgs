{ lib, stdenv, rustPlatform, fetchCrate, git, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "fac-build";
  version = "0.5.4";

  src = fetchCrate {
    inherit version;
    crateName = "fac";
    sha256 = "sha256-+JJVuKUdnjJoQJ4a2EE0O6jZdVoFxPwbPgfD2LfiDPI=";
  };


  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];
  cargoSha256 = "sha256-XT4FQVE+buORuZAFZK5Qnf/Fl3QSvw4SHUuCzWhxUdk=";

  # fac includes a unit test called ls_files_works which assumes it's
  # running in a git repo. Nix's sandbox runs cargo build outside git,
  # so this test won't work.
  checkFlagsArray = [ "--skip=ls_files_works" ];

  # fac calls git at runtime, expecting it to be in the PATH,
  # so we need to patch it to call git by absolute path instead.
  postPatch = ''
    substituteInPlace src/git.rs \
        --replace 'std::process::Command::new("git")' \
        'std::process::Command::new("${git}/bin/git")'
    substituteInPlace tests/lib.rs \
        --replace 'std::process::Command::new("git")' \
        'std::process::Command::new("${git}/bin/git")'
  '';

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = ''
      A build system that uses ptrace to handle dependencies automatically
    '';
    longDescription = ''
      Fac is a general-purpose build system inspired by make that utilizes
      ptrace to ensure that all dependences are enumerated and that all
      source files are added to a (git) repo. An important feature of fac
      is that it automatically handles dependencies, rather than either
      complaining about them or giving an incorrect build. Currently, fac
      only runs on linux systems, but on those systems it is incredibly
      easy to use!
    '';
    homepage = "https://physics.oregonstate.edu/~roundyd/fac";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dpercy ];
    mainProgram = "fac";
  };
}
