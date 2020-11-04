{ stdenv, fetchFromGitHub, rustPlatform, coreutils }:

rustPlatform.buildRustPackage rec {
  pname = "heatseeker";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "rschmitt";
    repo = "heatseeker";
    rev = "v${version}";
    sha256 = "1x7mdyf1m17s55f6yjdr1j510kb7a8f3zkd7lb2kzdc7nd3vgaxg";
  };

  cargoSha256 = "0jnlcm7v29m4nc318qgf7r7jvs80s7n04fw83imm506vwr9rxbx9";

  # https://github.com/rschmitt/heatseeker/issues/42
  # I've suggested using `/usr/bin/env stty`, but doing that isn't quite as simple
  # as a substitution, and this works since we have the path to coreutils stty.
  patchPhase = ''
    substituteInPlace src/screen/unix.rs --replace "/bin/stty" "${coreutils}/bin/stty"
  '';

  # some tests require a tty, this variable turns them off for Travis CI,
  # which we can also make use of
  TRAVIS = "true";

  meta = with stdenv.lib; {
    description = "A general-purpose fuzzy selector";
    homepage = "https://github.com/rschmitt/heatseeker";
    license = licenses.mit;
    maintainers = [ maintainers.michaelpj ];
    platforms = platforms.unix;
  };
}
