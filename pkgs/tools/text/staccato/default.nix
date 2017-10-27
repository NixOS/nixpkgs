{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name = "staccato-${version}";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "tshlabs";
    repo = "staccato";
    rev = version;
    sha256 = "1zbd1gx0ik2r7bavcid776j37g6rzd3f6cs94kq1qar4gyf1gqjm";
  };

  cargoSha256 = "074mfyanwdykg6wci2ia63wcnnyik741g8n624pac215sg4i95h7";

  meta = {
    broken = true;
    description = "A command line program that lets you compute statistics from values from a file or standard input";
    longDescription = ''
      Staccato (`st` for short) is a command line program that lets you
      compute statistics from values from a file or standard input. It
      computes things about the stream of numbers like min, max, mean, median,
      and standard deviation. It can also compute these things about some
      subset of the stream, for example the lower 95% of values.
    '';
    homepage = https://docs.rs/crate/staccato;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.all;
  };
}
