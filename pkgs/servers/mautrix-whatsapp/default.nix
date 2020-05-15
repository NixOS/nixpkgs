{ stdenv, buildGoModule, fetchFromGitHub }:

let
webp = fetchFromGitHub {
  owner = "chai2010";
  repo = "webp";
  rev = "19c584e49a98c31e2138c82fd0108435cd80d182";
  sha256 = "1bqf1ifsfw5dwvnc9vl3dhp775qv5hgl34219lvnja0bj6pq5zks";
};
in
buildGoModule {
  pname = "mautrix-whatsapp-unstable";
  version = "2020-04-21-1";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = "mautrix-whatsapp";
    rev = "e0aea74abf090bc9dc499332b28bf03640c162f8";
    sha256 = "1gayjyh0x0axc1xak38zkdhvx6fy8pwlniqsirqy2mwcgkkll9i5";
  };

  vendorSha256 = "0j397zyjs7v5q2jjd3l0wz4lh1fh45whgxjp7cwgc332ch9j2010";

  overrideModAttrs = (_: {
      postBuild = ''
      rm -r vendor/github.com/chai2010/webp 
      cp -r --reflink=auto ${webp} vendor/github.com/chai2010/webp
      '';
    });

  meta = with stdenv.lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3;
    maintainers = with maintainers; [ vskilet ma27 ];
  };
}