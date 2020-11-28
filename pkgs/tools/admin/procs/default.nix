{ stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "procs";
  version = "0.10.9";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = pname;
    rev = "v${version}";
    sha256 = "1bxzwcj7jxv1hkbq84wigshni1ivdga7g77k3h9fxzn7c223yccd";
  };

  cargoSha256 = "1bf0r9kymc1w1rxpc0bjgj5faagmad9vh404n9860rpganrdjvkx";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "A modern replacement for ps written in Rust";
    homepage = "https://github.com/dalance/procs";
    license = licenses.mit;
    maintainers = with maintainers; [ dalance Br1ght0ne ];
    platforms = with platforms; linux ++ darwin;
  };
}
