{ stdenv, buildGoPackage, fetchFromGitHub, fetchpatch }:

buildGoPackage rec {
  name = "cfssl-${version}";
  version = "1.3.2";

  goPackagePath = "github.com/cloudflare/cfssl";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "cfssl";
    rev = version;
    sha256 = "0j2gz2vl2pf7ir7sc7jrwmjnr67hk4qhxw09cjx132jbk337jc9x";
  };

  # The following patch ensures that the auth-key decoder doesn't break,
  # if the auth-key file contains leading or trailing whitespaces.
  # https://github.com/cloudflare/cfssl/pull/923 is merged
  # remove patch when it becomes part of a release.
  patches = [
    (fetchpatch {
      url    = "https://github.com/cloudflare/cfssl/commit/7e13f60773c96644db9dd8d342d42fe3a4d26f36.patch";
      sha256 = "1z2v2i8yj7qpj8zj5f2q739nhrr9s59jwzfzk52wfgssl4vv5mn5";
    })
  ];

  meta = with stdenv.lib; {
    homepage = https://cfssl.org/;
    description = "Cloudflare's PKI and TLS toolkit";
    platforms = platforms.linux;
    license = licenses.bsd2;
    maintainers = with maintainers; [ mbrgm ];
  };
}
