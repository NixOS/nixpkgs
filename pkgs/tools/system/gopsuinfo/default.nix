{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gopsuinfo";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = "gopsuinfo";
    rev = "v${version}";
    sha256 = "sha256-atUx035Tyy73AUBvhyo8cUHID5pTKj2/+PX9i/TRfoE=";
  };

  vendorSha256 = "sha256-RsplFwUL4KjWaXE6xvURX+4wkNG+i+1oyBXwLyVcb2Q=";

  # Remove installing of binary from the Makefile (already taken care of by
  # `buildGoModule`)
  patches = [
    ./no_bin_install.patch
  ];

  # Fix absolute path of icons in the code
  postPatch = ''
    substituteInPlace gopsuinfo.go \
      --replace "/usr/share/gopsuinfo" "$out/usr/share/gopsuinfo"
  '';

  # Install icons
  postInstall = '' make install DESTDIR=$out '';

  meta = with lib; {
    description = "A gopsutil-based command to display system usage info";
    homepage = "https://github.com/nwg-piotr/gopsuinfo";
    license = licenses.bsd2;
    maintainers = with maintainers; [ otini ];
    platforms = platforms.linux;
  };
}
