{ fetchFromGitLab, applyPatches, fetchpatch }: rec {

  pname = "mobilizon";
  version = "3.2.0";

  src = applyPatches {
    src = fetchFromGitLab {
      domain = "framagit.org";
      owner = "framasoft";
      repo = pname;
      rev = version;
      sha256 = "sha256-zgHR0taMMMwAoJEJr5s1rmSwJh31+qAfPQW9DSDuC8A=";
    };
    patches = [
      # See https://framagit.org/framasoft/mobilizon/-/merge_requests/1452
      (fetchpatch {
        url = "https://framagit.org/framasoft/mobilizon/-/commit/856d236b141c96705e1211e780e3f0e8950bb48e.patch";
        sha256 = "sha256-uEPvoTPVWHdg/KPWMG/Ck2qUjC+EUO3hyZnzpFxuoL0=";
      })
    ];
  };
}
