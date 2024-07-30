{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, varnish, docutils, removeReferencesTo }:
let
  common = { version, hash, extraNativeBuildInputs ? [] }:
    stdenv.mkDerivation rec {
      pname = "${varnish.name}-modules";
      inherit version;

      src = fetchFromGitHub {
        owner = "varnish";
        repo = "varnish-modules";
        rev = version;
        inherit hash;
      };

      nativeBuildInputs = [
        autoreconfHook
        docutils
        pkg-config
        removeReferencesTo
        varnish.python  # use same python version as varnish server
      ];

      buildInputs = [ varnish ];

      postPatch = ''
        substituteInPlace bootstrap   --replace "''${dataroot}/aclocal"                  "${varnish.dev}/share/aclocal"
        substituteInPlace Makefile.am --replace "''${LIBVARNISHAPI_DATAROOTDIR}/aclocal" "${varnish.dev}/share/aclocal"
      '';

      postInstall = "find $out -type f -exec remove-references-to -t ${varnish.dev} '{}' +"; # varnish.dev captured only as __FILE__ in assert messages

      meta = with lib; {
        description = "Collection of Varnish Cache modules (vmods) by Varnish Software";
        homepage = "https://github.com/varnish/varnish-modules";
        inherit (varnish.meta) license platforms maintainers;
      };
    };
in
{
  modules15 = common {
    version = "0.15.1";
    hash = "sha256-Et/iWOk2FWJBDOpKjNXm4Nh5i1SU4zVPaID7kh+Uj9M=";
  };
  modules23 = common {
    version = "0.23.0";
    hash = "sha256-Dd1pLMmRC59iRRpReDeQJ8Sv00ojb8InvaMrb+iRv4I=";
  };
  modules24 = common {
    version = "0.24.0";
    hash = "sha256-2MfcrhhkBz9GyQxEWzjipdn1CBEqnCvC3t1G2YSauak=";
  };
}
