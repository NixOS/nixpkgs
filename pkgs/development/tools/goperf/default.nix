{ lib
, buildGoModule
, fetchgit
}:

buildGoModule rec {
  pname = "goperf";
  version = "unstable-2022-09-20";

  src = fetchgit {
    url = "https://go.googlesource.com/perf";
    rev = "e8d778a60d07b209c499efb221f76d51f63c6042";
    hash = "sha256-UuP528n5uAWMJCakc8MP8wlmA6SwMO/IaIqR88pqL7c=";
  };

  vendorHash = "sha256-ZIkH3LBzrvqWEN6m4fpU2cmOXup9LLU3FiFooJJtiOk=";

  meta = with lib; {
    description = "Tools and packages for analyzing Go benchmark results";
    homepage = "https://cs.opensource.google/go/x/perf";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ pbsds ];
  };
}
