{ stdenv
, lib
, buildGoModule
, fetchFromGitHub
, libpcap
}:

buildGoModule rec {
  pname = "sx-go";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "v-byte-cpu";
    repo = "sx";
    rev = "v${version}";
    sha256 = "0djpwy40wj5asky8a16i7a117816p8g94p5y0wkl74jp07cybmrl";
  };

  vendorSha256 = "0n1h9jch0zfafli8djjr6wkgfxxpnh4q873d5mr1xg8a25qhlifr";

  buildInputs = [
    libpcap
  ];

  postFixup = ''
    # Rename binary to avoid conflict with sx
    mv $out/bin/sx $out/bin/${pname}
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Command-line network scanner";
    homepage = "https://github.com/v-byte-cpu/sx";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
