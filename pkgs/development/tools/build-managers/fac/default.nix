{ lib, git, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "fac-build";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "droundy";
    repo = "fac";
    rev = version;
    sha256 = "1gifrlb31jy8633rnhny58ccp3wlmd338129c6sh0h1a38vkmsxk";
  };

  # workaround for missing Cargo.lock file
  cargoPatches = [ ./cargo-lock.patch ];

  cargoSha256 = "033wif3wwm3912ppw0gshsyjxipilg9hhvkijw29zmjfm6074b21";

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
  '';

  meta = with lib; {
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
    platforms = platforms.linux;
    maintainers = [ maintainers.dpercy ];
  };
}
