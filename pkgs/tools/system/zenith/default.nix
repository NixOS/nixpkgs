{ stdenv, rustPlatform, fetchFromGitHub, IOKit }:

rustPlatform.buildRustPackage rec {
  pname = "zenith";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "bvaisvil";
    repo = pname;
    rev = version;
    sha256 = "1yfbr8zmcy7zp9s9cqv7qypj2vvhpq09r0398gr7ckjk6v70hhfg";
  };

  cargoSha256 = "1l4cjcpfghis983y31s54fzjppdnh3wa4anwi7bdsbyvqz3n3ywj";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ IOKit ];

  preBuild = ''
    export CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_LINKER=gcc
  '';

  meta = with stdenv.lib; {
    description = "Sort of like top or htop but with zoom-able charts, network, and disk usage";
    homepage = "https://github.com/bvaisvil/zenith";
    license = licenses.mit;
    maintainers = with maintainers; [ bbigras ];
    platforms = platforms.all;
  };
}
