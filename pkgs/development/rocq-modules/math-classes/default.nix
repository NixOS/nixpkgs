{
  lib,
  mkCoqDerivation,
  coq,
  bignums,
  version ? null,
}:

mkCoqDerivation {

  pname = "math-classes";
  inherit version;
  defaultVersion =
    let
      case = case: out: { inherit case out; };
    in
    with lib.versions;
    lib.switch coq.coq-version [
      (case (range "9.0" "9.3") "9.2.0")
      (case (range "9.0" "9.1") "9.0.0")
      (case (range "8.17" "8.20") "8.19.0")
      (case (range "8.12" "8.18") "8.18.0")
      (case (range "8.12" "8.17") "8.17.0")
      (case (range "8.6" "8.16") "8.15.0")
    ] null;
  release."8.12.0".hash = "sha256:14nd6a08zncrl5yg2gzk0xf4iinwq4hxnsgm4fyv07ydbkxfb425";
  release."8.13.0".hash = "sha256:1ln7ziivfbxzbdvlhbvyg3v30jgblncmwcsam6gg3d1zz6r7cbby";
  release."8.15.0".hash = "sha256:10w1hm537k6jx8a8vghq1yx12rsa0sjk2ipv3scgir71ln30hllw";
  release."8.17.0".hash = "sha256-WklL8pgYTd0l4TGt7h7tWj1qcFcXvoPn25+XKF1pIKA=";
  release."8.18.0".hash = "sha256-0WwPss8+Vr37zX616xeuS4TvtImtSbToFQkQostIjO8=";
  release."8.19.0".hash = "sha256-rsV96W9MPFi/DKsepNPm1QnC2DMemio+uALIgzVYw0w=";
  release."9.0.0".hash = "sha256-b8GPb1MRg5ZLieDTaoozy6ju10FhVdb6/XhKmyac1V4=";
  release."9.2.0".hash = "sha256-NdmZcaNg0AmJXRsB3reyxrOYOnj/ZHgv3kF9Bxw+Q3I=";

  mlPlugin = true; # uses coq-bignums.plugin

  propagatedBuildInputs = [ bignums ];

  meta = {
    homepage = "https://math-classes.github.io";
    description = "Library of abstract interfaces for mathematical structures in Coq";
    maintainers = with lib.maintainers; [
      siddharthist
      jwiegley
    ];
  };
}
