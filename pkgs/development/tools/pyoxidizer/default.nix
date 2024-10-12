{ lib
, stdenv
, fetchFromGitHub
, python3
, rustPlatform
, CoreFoundation
, Security
}:

rustPlatform.buildRustPackage rec {
    pname = "PyOxidizer";
    version = "0.24.0";

  src = fetchFromGitHub {
    owner = "indygreg";
    repo = pname;
    rev = "pyoxidizer/${version}";
    sha256 = "sha256-SD+e3ufgkNvvvy0JTL+UPo8VRVZiN64W3NuChjhfr6Y=";
  };

  cargoSha256 = "sha256-BfZsDmd/9ldvH2/0WnrFgn8PYsG3/uXaPRVKP/dnHGw=";
  depsBuildBuild = [ python3 ];
  buildInputs = [ python3 ] ++ lib.optionals stdenv.isDarwin [ CoreFoundation Security ];

  # many tests fail
  doCheck = false;

  meta = with lib; {
    description = "A modern Python application packaging and distribution tool";
    homepage = "https://github.com/indygreg/PyOxidizer";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ deejayem ];
  };
}
