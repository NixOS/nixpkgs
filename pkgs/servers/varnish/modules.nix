{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, varnish, docutils, removeReferencesTo }:
let
  common = { version, sha256, extraNativeBuildInputs ? [] }:
    stdenv.mkDerivation rec {
      pname = "${varnish.name}-modules";
      inherit version;

      src = fetchFromGitHub {
        owner = "varnish";
        repo = "varnish-modules";
        rev = version;
        inherit sha256;
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
    sha256 = "1lwgjhgr5yw0d17kbqwlaj5pkn70wvaqqjpa1i0n459nx5cf5pqj";
  };
  modules23 = common {
    version = "0.23.0";
    sha256 = "sha256-Dd1pLMmRC59iRRpReDeQJ8Sv00ojb8InvaMrb+iRv4I=";
  };
}
