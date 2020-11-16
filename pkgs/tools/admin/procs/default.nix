{ stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "procs";
  version = "0.10.7";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = pname;
    rev = "v${version}";
    sha256 = "0aaspzx8sna1m5zldql0ps3sldazwr32q0md0p8z3nimww24i3b3";
  };

  cargoSha256 = "1nb38nnmmc4hf8crp0bka029hlph15zm796nqziq25i26cgz4xvp";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "A modern replacement for ps written in Rust";
    homepage = "https://github.com/dalance/procs";
    license = licenses.mit;
    maintainers = with maintainers; [ dalance filalex77 ];
    platforms = with platforms; linux ++ darwin;
  };
}
