{ lib, buildGoPackage, fetchFromGitHub, fetchpatch }:

let
  generic = { patches ? [] }:
    buildGoPackage rec {
      version = "1.6.4";
      pname = "certmgr";

      goPackagePath = "github.com/cloudflare/certmgr/";

      src = fetchFromGitHub {
        owner = "cloudflare";
        repo = "certmgr";
        rev = "v${version}";
        sha256 = "0glvyp61ya21pdm2bsvq3vfhmmxc2998vxc6hiyc79ijsv9n6jqi";
      };

      inherit patches;

      meta = with lib; {
        homepage = "https://cfssl.org/";
        description = "Cloudflare's certificate manager";
        platforms = platforms.linux;
        license = licenses.bsd2;
        maintainers = with maintainers; [ johanot srhb ];
      };
    };
in
{
  certmgr = generic {};

  certmgr-selfsigned = generic {
    # The following patch makes it possible to use a self-signed x509 cert
    # for the cfssl apiserver.
    # TODO: remove patch when PR is merged.
    patches = [
      (fetchpatch {
        # https://github.com/cloudflare/certmgr/pull/51
        name   = "cloudflare-certmgr-pull-51.patch";
        url    = "https://github.com/cloudflare/certmgr/compare/232e0adf8379db28ab74c46e0dd3eddb3cd8f2ea...55c595a4a2dc871726b3c8337469daf5597718a3.patch";
        sha256 = "0jhsw159d2mgybvbbn6pmvj4yqr5cwcal5fjwkcn9m4f4zlb6qrs";
      })
    ];
  };
}
