{rustPlatform, fetchFromGitHub, lib}:
rustPlatform.buildRustPackage rec {
  pname = "rbspy";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v0.10.0";
    sha256 = "sha256-zvH2oPm2tOdk4C5EDNhNgO9nt4usnuBTp+fh6xfwraQ=";
  };

  cargoSha256 = "sha256-Es4COQiNZmbGdWeSyOvx4tiV1ygic3VPQLTiispVWpM=";
  doCheck = false;

  meta = with lib; {
    homepage = "https://rbspy.github.io/";
    description = ''
      A Sampling CPU Profiler for Ruby.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ viraptor ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
