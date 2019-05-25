{ stdenv, rustPlatform, fetchFromGitHub, CoreServices, darwin }:

rustPlatform.buildRustPackage rec {
  name = "watchexec-${version}";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "watchexec";
    repo = "watchexec";
    rev = version;
    sha256 = "0azfnqx5v1shsd7jdxzn41awh9dbjykv8h1isrambc86ygr1c1cy";
  };

  cargoSha256 = "0rc1p5q3ihcak7vlmzwawdbgcp1kvj5qjr7p4r1zk9fnhijmrjg9";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [
    CoreServices
    # This is needed to avoid an undefined symbol error "_CFURLResourceIsReachable"
    darwin.cf-private
  ];

  meta = with stdenv.lib; {
    description = "Executes commands in response to file modifications";
    homepage = https://github.com/watchexec/watchexec;
    license = with licenses; [ asl20 ];
    maintainers = [ maintainers.michalrus ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
