{ stdenv, rustPlatform, fetchFromGitHub, lib}:
rustPlatform.buildRustPackage rec {
  pname = "rbspy";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-9BeQHwwnirK5Wquj6Tal8yCU/NXZGaPjXZe3cy5m98s=";
  };

  cargoSha256 = "sha256-DHdfv6210wAkL9vXxLr76ejFWU/eV/q3lmgsYa5Rn54=";
  doCheck = true;

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    homepage = "https://rbspy.github.io/";
    description = ''
      A Sampling CPU Profiler for Ruby.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ viraptor ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
