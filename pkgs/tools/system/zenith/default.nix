{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "zenith";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "bvaisvil";
    repo = pname;
    rev = version;
    sha256 = "1m709mnhhjs30s91542rhri3xbzsb3kw8zablvn11rwp2iq1lxxx";
  };

  cargoSha256 = "1j6pww4mpssnr9zsbfy74llv7336kjrif1qiph998b82qj63vdlg";

  meta = with stdenv.lib; {
    description = "Sort of like top or htop but with zoom-able charts, network, and disk usage";
    homepage = "https://github.com/bvaisvil/zenith";
    license = licenses.mit;
    maintainers = with maintainers; [ bbigras ];
    platforms = platforms.x86;
  };
}
