{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "shotgun";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "neXromancers";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ovqPBZznDQnQa9YW1xXA02Jl0AQ7sJNpzovA1SVR8Zc=";
  };

  cargoSha256 = "sha256-mWifSN9Hpsivq0RdZ9l9+8CWaZMHfzzhT2r27FAuesU=";

  meta = with lib; {
    description = "Minimal X screenshot utility";
    homepage = "https://github.com/neXromancers/shotgun";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ figsoda lumi novenary ];
    platforms = platforms.linux;
  };
}
