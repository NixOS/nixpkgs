{ stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "procs";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = pname;
    rev = "v${version}";
    sha256 = "1c2faw88np5dsbnd915m9a2fkx3a7xy9ii0xvacxkrv3z2zab3fc";
  };

  cargoSha256 = "11wv02nn6gp32zzcd6kmsh6ky0dzyk1qqhb5vxvmq2nxhxjlddwv";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "A modern replacement for ps written in Rust";
    homepage = "https://github.com/dalance/procs";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.dalance ];
    platforms = with platforms; linux ++ darwin;
  };
}
