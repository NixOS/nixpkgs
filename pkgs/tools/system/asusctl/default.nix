{ lib
, fetchFromGitLab
, fetchpatch
, rustPlatform
, pkg-config
, udev
}:
rustPlatform.buildRustPackage rec {
  pname = "asusctl";
  version = "git-3cd6eb";
  src = fetchFromGitLab {
    owner = "asus-linux";
    repo = pname;
    rev = "3cd6eb13a95992db9a0c7d1d5dc441ab292205c7";
    sha256 = "sha256-sA/ZbqPsctMd5sCjWd0i22KCA/TqSMMVAEVKWFlZyWM=";
  };
  cargoHash = "sha256-LbzULOU6osoK52KUMyNHMbAgqaOYDk2z1UhZ8PCR28U=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ udev ];

  postInstall = ''
    make install INSTALL_PROGRAM=true DESTDIR=$out prefix=
  '';

  meta = {
    description = "Control utility for ASUS ROG";
    longDescription = ''
      asusd is a utility for Linux to control many aspects of various ASUS
      laptops but can also be used with non-asus laptops with reduced features.
    '';
    homepage = "https://asus-linux.org";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ sauricat ];
  };
}
