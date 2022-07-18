{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "waitron";
  version = "unstable-2020-08-04";
  rev = "2315857d94e3d1a1e79ac48f8f6a68d59d0ce300";

  src = fetchFromGitHub {
    owner = "ns1";
    repo = "waitron";
    inherit rev;
    sha256 = "sha256-ZkGhEOckIOYGb6Yjr4I4e9cjAHDfksRwHW+zgOMZ/FE=";
  };

  vendorSha256 = "sha256-grQFLo0BIIa/kNKF4vPw/V1WN9sxOucz6+wET2PBU1I=";

  subPackages = [ "." ];

  patches = [
    ./staticfiles-directory.patch
  ];

  meta = with lib; {
    description = "A tool to manage network booting of machines";
    longDescription = ''
      Waitron is used to build machines (primarily bare-metal, but anything that
      understands PXE booting will work) based on definitions from any number of
      specified inventory sources.
    '';
    homepage = "https://github.com/ns1/waitron";
    license =  licenses.asl20;
    maintainers = with maintainers; [ guibert ];
    platforms = platforms.linux;
  };
}
