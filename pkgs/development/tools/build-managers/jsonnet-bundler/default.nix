{ stdenv, buildGoModule, fetchgit, lib }:

buildGoModule rec {
  pname = "jsonnet-bundler";
  version = "20200804-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "ada055a225fa6fc37b05bdbd838ed91b04727a6e";

  src = fetchGit {
    url = "https://github.com/jsonnet-bundler/jsonnet-bundler";
    inherit rev;
  };

  deleteVendor=true;
  vendorSha256 = "1h1d32zi1pfb7spprsacxg8ygrigswqqngrc8gsdzn1xbldphl5g";

  meta = with lib; {
    description = "A package manager for Jsonnet";
    homepage = "https://github.com/jsonnet-bundler/jsonnet-bundler";
    license = licenses.asl20;
    maintainers = with maintainers; [ mikefaille ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
