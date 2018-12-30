{callPackage, fetchFromGitHub, fetchpatch}:
callPackage ./dvtm.nix {
  name = "dvtm-unstable-2018-03-31";

  src = fetchFromGitHub {
    owner = "martanne";
    repo = "dvtm";
    rev = "311a8c0c28296f8f87fb63349e0f3254c7481e14";
    sha256 = "0pyxjkaxh8n97kccnmd3p98vi9h8mcfy5lswzqiplsxmxxmlbpx2";
  };

  patches = [
    # https://github.com/martanne/dvtm/pull/69
    # Use self-pipe instead of signal blocking fixes issues on darwin.
    (fetchpatch {
      name = "use-self-pipe-fix-darwin";
      url = "https://github.com/martanne/dvtm/commit/1f1ed664d64603f3f1ce1388571227dc723901b2.patch";
      sha256 = "14j3kks7b1v6qq12442v1da3h7khp02rp0vi0qrz0rfgkg1zilpb";
    })

    # https://github.com/martanne/dvtm/pull/86
    # Fix buffer corruption when title is updated
    (fetchpatch {
      name = "fix-buffer-corruption-on-title-update";
      url = "https://github.com/martanne/dvtm/commit/be6c3f8f615daeab214d484e6fff22e19631a0d1.patch";
      sha256 = "1wdrl3sg815lhs22fwbc4w5dn4ifpdgl7v1kqfnhg752av4im7h7";
    })
  ];
}
