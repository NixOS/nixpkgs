{ stdenv, rustPlatform, fetchFromGitHub, IOKit }:

rustPlatform.buildRustPackage rec {
  pname = "zenith";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "bvaisvil";
    repo = pname;
    rev = version;
    sha256 = "12wbx4zhf1rf13g3mw8vcn8aqk9vcza61vi42y6c1pb2km73qw1h";
  };

  cargoPatches = [ ./cargo-lock.patch ];
  cargoSha256 = "1nyci2vjwsyfscsd520d1r5vyazb33hv4mrsysy6amss4jdf2dlq";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ IOKit ];

  meta = with stdenv.lib; {
    description = "Sort of like top or htop but with zoom-able charts, network, and disk usage";
    homepage = "https://github.com/bvaisvil/zenith";
    license = licenses.mit;
    maintainers = with maintainers; [ bbigras ];
    # doesn't build on aarch64 https://github.com/bvaisvil/zenith/issues/19
    platforms = platforms.x86;
  };
}
