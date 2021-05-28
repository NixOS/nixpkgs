{ stdenv, rustPlatform, fetchFromGitHub, IOKit }:

rustPlatform.buildRustPackage rec {
  pname = "zenith";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "bvaisvil";
    repo = pname;
    rev = version;
    sha256 = "0jz0pjibjiyg0rjmpihxxjhg9cbccvqfr5si5rji585l0zrpdwsg";
  };

  cargoSha256 = "1zkx6sr5xlj7pb91bxvqjib5awscy1rmv4g89xb76dahac8fan6z";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ IOKit ];

  meta = with stdenv.lib; {
    description = "Sort of like top or htop but with zoom-able charts, network, and disk usage";
    homepage = "https://github.com/bvaisvil/zenith";
    license = licenses.mit;
    maintainers = with maintainers; [ bbigras ];
    # doesn't build on aarch64 https://github.com/bvaisvil/zenith/issues/19
    # see https://github.com/NixOS/nixpkgs/pull/88616
    platforms = platforms.x86;
  };
}
