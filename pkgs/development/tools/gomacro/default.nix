{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gomacro";
  rev = "b4c3ab9b218fd12f22759354f4f3e37635828d1f";
  version = "20210131-${lib.strings.substring 0 7 rev}";

  src = fetchFromGitHub {
    owner = "cosmos72";
    repo = "gomacro";
    inherit rev;
    hash = "sha256-zxiEt/RR7g5Q0wMLuRaybnT5dFfPCyvt0PvDjL9BJDI=";
  };

  vendorHash = "sha256-fQYuav0pT+/fGq0fmOWlsiVxA9tGV4JV8X7G3E6BZMU=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Interactive Go interpreter and debugger with generics and macros";
    homepage = "https://github.com/cosmos72/gomacro";
    license = licenses.mpl20;
    maintainers = with maintainers; [ shofius ];
  };
}
